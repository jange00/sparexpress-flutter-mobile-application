import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sparexpress/core/common/snackbar/my_snackbar.dart';

class ProximitySensorService {
  static final ProximitySensorService _instance = ProximitySensorService._internal();
  factory ProximitySensorService() => _instance;
  ProximitySensorService._internal();

  StreamSubscription<int>? _proximitySubscription;
  bool _isNear = false;
  bool _isEnabled = false;
  BuildContext? _context;
  Timer? _warningTimer;
  int _nearDuration = 0;
  
  // Configuration
  static const int _warningThreshold = 3; // seconds
  static const int _criticalThreshold = 10; // seconds
  static const double _checkInterval = 1.0; // seconds

  // Callbacks
  Function(bool)? _onProximityChanged;
  Function(String)? _onWarning;

  /// Initialize the proximity sensor service
  Future<bool> initialize(BuildContext context) async {
    try {
      _context = context;
      
      // Check if proximity sensor is available (try-catch approach)
      bool isAvailable = false;
      try {
        // Try to start listening to check availability
        final testSubscription = ProximitySensor.events.listen((event) {});
        await testSubscription.cancel();
        isAvailable = true;
      } catch (e) {
        debugPrint('Proximity sensor is not available on this device: $e');
        return false;
      }

      _isEnabled = true;
      _startListening();
      return true;
    } catch (e) {
      debugPrint('Failed to initialize proximity sensor: $e');
      return false;
    }
  }

  /// Start listening to proximity sensor events
  void _startListening() {
    if (!_isEnabled) return;

    _proximitySubscription = ProximitySensor.events.listen(
      (int event) {
        final wasNear = _isNear;
        _isNear = (event > 0);
        
        if (_isNear != wasNear) {
          _onProximityChanged?.call(_isNear);
          _handleProximityChange();
        }
      },
      onError: (error) {
        debugPrint('Proximity sensor error: $error');
      },
    );
  }

  /// Handle proximity state changes
  void _handleProximityChange() {
    if (_isNear) {
      _startWarningTimer();
      _showProximityWarning();
    } else {
      _stopWarningTimer();
      _nearDuration = 0;
      _hideProximityWarning();
    }
  }

  /// Start timer to track how long device is near
  void _startWarningTimer() {
    _warningTimer?.cancel();
    _warningTimer = Timer.periodic(
      Duration(milliseconds: (_checkInterval * 1000).round()),
      (timer) {
        _nearDuration++;
        _checkWarningThresholds();
      },
    );
  }

  /// Stop the warning timer
  void _stopWarningTimer() {
    _warningTimer?.cancel();
    _warningTimer = null;
  }

  /// Check if warning thresholds are met
  void _checkWarningThresholds() {
    if (_nearDuration == _warningThreshold) {
      _showWarningMessage(
        '⚠️ Device too close!',
        'Please move your device away from your face to prevent eye strain.',
        Colors.orange,
      );
    } else if (_nearDuration == _criticalThreshold) {
      _showWarningMessage(
        '🚨 Critical Warning!',
        'Your device is very close to your face. This may cause eye strain and discomfort.',
        Colors.red,
      );
    } else if (_nearDuration > _criticalThreshold && _nearDuration % 5 == 0) {
      _showWarningMessage(
        '⚠️ Prolonged Close Usage',
        'Consider taking a break and moving your device further away.',
        Colors.red,
      );
    }
  }

  /// Show proximity warning overlay
  void _showProximityWarning() {
    if (_context == null) return;
    
    _onWarning?.call('Device detected near face');
    
    // Show a subtle indicator
    showAppSnackBar(
      _context!,
      message: '📱 Device proximity detected',
      icon: Icons.visibility_off,
      backgroundColor: Colors.blue[700],
      duration: const Duration(seconds: 2),
    );
  }

  /// Hide proximity warning
  void _hideProximityWarning() {
    if (_context == null) return;
    
    _onWarning?.call('Device moved away');
    
    // Show confirmation
    showAppSnackBar(
      _context!,
      message: '✅ Safe distance maintained',
      icon: Icons.visibility,
      backgroundColor: Colors.green[700],
      duration: const Duration(seconds: 2),
    );
  }

  /// Show warning message
  void _showWarningMessage(String title, String message, Color color) {
    if (_context == null) return;
    
    _onWarning?.call(message);
    
    showAppSnackBar(
      _context!,
      message: message,
      icon: Icons.warning,
      backgroundColor: color,
      duration: const Duration(seconds: 4),
    );
  }

  /// Set callbacks for proximity events
  void setCallbacks({
    Function(bool)? onProximityChanged,
    Function(String)? onWarning,
  }) {
    _onProximityChanged = onProximityChanged;
    _onWarning = onWarning;
  }

  /// Get current proximity state
  bool get isNear => _isNear;
  
  /// Get how long device has been near (in seconds)
  int get nearDuration => _nearDuration;
  
  /// Check if service is enabled
  bool get isEnabled => _isEnabled;

  /// Pause the proximity sensor
  void pause() {
    _stopWarningTimer();
    _proximitySubscription?.pause();
  }

  /// Resume the proximity sensor
  void resume() {
    if (_isEnabled) {
      _proximitySubscription?.resume();
      if (_isNear) {
        _startWarningTimer();
      }
    }
  }

  /// Dispose of resources
  void dispose() {
    _stopWarningTimer();
    _proximitySubscription?.cancel();
    _proximitySubscription = null;
    _context = null;
    _isEnabled = false;
  }
} 