import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_event.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:async';

class LogoutCard extends StatefulWidget {
  final BuildContext blocContext;
  const LogoutCard({super.key, required this.blocContext});

  @override
  State<LogoutCard> createState() => _LogoutCardState();
}

class _LogoutCardState extends State<LogoutCard> {
  Stream<bool>? _proximityStream;
  bool _isDialogOpen = false;
  bool _proximityEnabled = false;
  Stream<bool>? _activeProximityStream;
  StreamSubscription<bool>? _proximitySubscription;

  @override
  void dispose() {
    _proximitySubscription?.cancel();
    super.dispose();
  }

  void _setProximityActive(bool active) {
    setState(() {
      _proximityEnabled = active;
    });
    _proximitySubscription?.cancel();
    if (active) {
      _activeProximityStream = ProximitySensor.events.map((event) => event > 0);
      _proximitySubscription = _activeProximityStream?.listen((isNear) {
        if (isNear && !_isDialogOpen && mounted) {
          _isDialogOpen = true;
          _showLogoutDialog(context);
        }
      });
    } else {
      _activeProximityStream = null;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, color: Theme.of(context).colorScheme.primary, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    "Confirm Logout",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Are you sure you want to logout from your account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() => _isDialogOpen = false);
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.blocContext.read<AccountBloc>().add(LogoutRequested());
                            setState(() => _isDialogOpen = false);
                          },
                          child: const Text("Logout"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (mounted) setState(() => _isDialogOpen = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.logout, color: colorScheme.primary),
        title: Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.onSurface),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Proximity Logout"),
            Switch(
              value: _proximityEnabled,
              onChanged: _setProximityActive,
              activeColor: colorScheme.primary,
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurface.withOpacity(0.6)),
          ],
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }
}
