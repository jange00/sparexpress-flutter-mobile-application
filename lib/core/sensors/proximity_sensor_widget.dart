import 'package:flutter/material.dart';
import 'package:sparexpress/core/sensors/proximity_sensor_service.dart';

class ProximitySensorWidget extends StatefulWidget {
  final Widget child;
  final bool showVisualIndicator;
  final bool enableWarnings;
  final Function(bool)? onProximityChanged;
  final Function(String)? onWarning;

  const ProximitySensorWidget({
    super.key,
    required this.child,
    this.showVisualIndicator = true,
    this.enableWarnings = true,
    this.onProximityChanged,
    this.onWarning,
  });

  @override
  State<ProximitySensorWidget> createState() => _ProximitySensorWidgetState();
}

class _ProximitySensorWidgetState extends State<ProximitySensorWidget>
    with WidgetsBindingObserver {
  final ProximitySensorService _proximityService = ProximitySensorService();
  bool _isNear = false;
  bool _isInitialized = false;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeProximitySensor();
  }

  Future<void> _initializeProximitySensor() async {
    try {
      _isAvailable = await _proximityService.initialize(context);
      
      if (_isAvailable) {
        _proximityService.setCallbacks(
          onProximityChanged: (isNear) {
            setState(() {
              _isNear = isNear;
            });
            widget.onProximityChanged?.call(isNear);
          },
          onWarning: (message) {
            widget.onWarning?.call(message);
          },
        );
      }
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Failed to initialize proximity sensor: $e');
      setState(() {
        _isInitialized = true;
        _isAvailable = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _proximityService.pause();
        break;
      case AppLifecycleState.resumed:
        _proximityService.resume();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _proximityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        widget.child,
        
        // Proximity indicator overlay
        if (widget.showVisualIndicator && 
            _isInitialized && 
            _isAvailable && 
            _isNear)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.visibility_off,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Too Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
} 