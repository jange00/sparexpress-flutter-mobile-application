import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/auth/domain/use_case/delete_user_usecase.dart';

class DeleteAccountCard extends StatelessWidget {
  final VoidCallback onDelete;
  const DeleteAccountCard({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.delete_forever, color: Colors.red, size: 32),
        title: const Text(
          'Delete Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
        ),
        subtitle: const Text(
          'Permanently delete your account and all data.',
          style: TextStyle(color: Colors.red, fontSize: 13),
        ),
        onTap: onDelete,
      ),
    );
  }
}

Future<void> deleteAccountHelper(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please log in again.')),
      );
      return;
    }
    print('Deleting user: $userId');
    final deleteUserUsecase = serviceLocator<DeleteUserUsecase>();
    await deleteUserUsecase(userId);
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
} 