import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class ShakeLogoutProvider extends ChangeNotifier {
  bool _enabled = false;
  bool get enabled => _enabled;
  StreamSubscription<AccelerometerEvent>? _shakeSubscription;
  BuildContext? _logoutContext;
  bool _isDialogOpen = false;
  VoidCallback? _onLogout;

  void setLogoutContext(BuildContext context) {
    print('[ShakeLogoutProvider] setLogoutContext called');
    _logoutContext = context;
  }

  void setLogoutCallback(VoidCallback callback) {
    print('[ShakeLogoutProvider] setLogoutCallback called');
    _onLogout = callback;
  }

  void setShakeEnabled(bool value) {
    print('[ShakeLogoutProvider] setShakeEnabled: $value');
    _enabled = value;
    notifyListeners();
    _shakeSubscription?.cancel();
    if (value) {
      _shakeSubscription = accelerometerEvents.listen(_onAccelerometerEvent);
    }
  }

  // Shake detection logic
  static const double shakeThreshold = 10.0;
  int _lastShakeTimestamp = 0;

  void _onAccelerometerEvent(AccelerometerEvent event) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final double gX = event.x / 9.8;
    final double gY = event.y / 9.8;
    final double gZ = event.z / 9.8;
    final double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);
    if (gForce > shakeThreshold) {
      // Debounce: only trigger once every 1.5 seconds
      if (now - _lastShakeTimestamp > 1500 && !_isDialogOpen && _logoutContext != null) {
        print('[ShakeLogoutProvider] Shake detected! gForce: $gForce');
        _lastShakeTimestamp = now;
        _isDialogOpen = true;
        _showLogoutDialog(_logoutContext!);
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    print('[ShakeLogoutProvider] _showLogoutDialog called');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _isDialogOpen = false;
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _isDialogOpen = false;
              print('[ShakeLogoutProvider] Logout callback triggered');
              if (_onLogout != null) {
                _onLogout!();
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    ).then((_) => _isDialogOpen = false);
  }

  @override
  void dispose() {
    _shakeSubscription?.cancel();
    super.dispose();
  }
} 