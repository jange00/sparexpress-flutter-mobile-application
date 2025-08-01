import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_event.dart';


class LogoutCard extends StatefulWidget {
  final BuildContext blocContext;
  const LogoutCard({super.key, required this.blocContext});

  @override
  State<LogoutCard> createState() => _LogoutCardState();
}

class _LogoutCardState extends State<LogoutCard> {


  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: (){
                    widget.blocContext.read<AccountBloc>().add(LogoutRequested());
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
        trailing: Icon(Icons.chevron_right, color: colorScheme.onSurface.withOpacity(0.6)),
        onTap: () {
          _showLogoutDialog();
        },
      ),
    );
  }
}
