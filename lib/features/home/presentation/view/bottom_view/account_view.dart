import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/about_us/about_us_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/change_password/change_password_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/change_password/change_password_overlay.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/logout/logout_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/profile_header/profile_header_card.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    const String name = "Sushant Mahato";
    const String email = "sushant@example.com";
    const String phoneNumber = "+977 9800000000";
    const String imageUrl = "https://i.pravatar.cc/150?img=3";

    return BlocProvider(
      create: (context) => AccountBloc(context: context),
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is LogoutConfirmed) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) =>  LoginView()),
              (route) => false,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileHeaderCard(
                    name: name,
                    email: email,
                    phoneNumber: phoneNumber,
                    imageUrl: imageUrl,
                  ),
                  const SizedBox(height: 16),
    ChangePasswordCard(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => const ChangePasswordOverlay(),
        );
      },
    ),
                     const SizedBox(height: 16),
                  // Expanded(child: const AboutUsCard()),
                  const AboutUsCard(),
                  const SizedBox(height: 16),
                  const LogoutCard(),  
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
