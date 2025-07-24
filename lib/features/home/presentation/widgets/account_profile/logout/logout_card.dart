import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_event.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'proximity_provider.dart';

class LogoutCard extends StatelessWidget {
  final BuildContext blocContext;
  const LogoutCard({super.key, required this.blocContext});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shakeProvider = Provider.of<ShakeLogoutProvider>(context);
    // Set the logout context so the provider can show dialogs globally
    shakeProvider.setLogoutContext(blocContext);
    shakeProvider.setLogoutCallback(() {
      blocContext.read<AccountBloc>().add(LogoutRequested());
    });
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
              value: shakeProvider.enabled,
              onChanged: (val) => shakeProvider.setShakeEnabled(val),
              activeColor: colorScheme.primary,
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurface.withOpacity(0.6)),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout from your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    blocContext.read<AccountBloc>().add(LogoutRequested());
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
