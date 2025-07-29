import 'dart:async';
import 'package:flutter/material.dart';
import 'internet_checker.dart';

class GlobalConnectivityBanner extends StatefulWidget {
  final Widget child;
  const GlobalConnectivityBanner({Key? key, required this.child}) : super(key: key);

  @override
  State<GlobalConnectivityBanner> createState() => _GlobalConnectivityBannerState();
}

class _GlobalConnectivityBannerState extends State<GlobalConnectivityBanner> {
  bool _isOffline = false;
  late final Stream<bool> _stream;
  late final StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    _stream = InternetChecker.onStatusChange;
    _subscription = _stream.listen((connected) {
      if (mounted) setState(() => _isOffline = !connected);
    });
    // Initial check
    InternetChecker.isConnected().then((connected) {
      if (mounted) setState(() => _isOffline = !connected);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isOffline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.red,
              elevation: 8,
              child: SafeArea(
                bottom: false,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.wifi_off, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'No internet connection',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
} 