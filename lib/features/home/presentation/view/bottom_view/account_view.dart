import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/about_us/about_us_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/change_password/change_password_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/change_password/change_password_overlay.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/contact_us/contact_us_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/contact_us/contact_us_overlay.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/logout/logout_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/profile_header/profile_header_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/theme_toggle_card.dart';
import 'package:sparexpress/features/splash/presentation/view/splash_view.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sparexpress/app/app.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/payment/payment_card.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/payment_view_model/payment_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/payment_view_model/payment_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/payment_view_model/payment_state.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/payment/payment_overlay.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModeNotifier>(context);
    final isDark = themeNotifier.themeMode == ThemeMode.dark ||
        (themeNotifier.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    const String name = "Sushant Mahato";
    const String email = "sushant@example.com";
    const String phoneNumber = "+977 9800000000";
    const String imageUrl = "https://i.pravatar.cc/150?img=3";

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is LogoutConfirmed) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: serviceLocator<SplashViewModel>(),
                child: SplashView(),
              ),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepOrange,
          elevation: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ProfileHeaderCard(
                  name: name,
                  email: email,
                  phoneNumber: phoneNumber,
                  imageUrl: imageUrl,
                ),
                const SizedBox(height: 24),
                // Theme toggle card
                ThemeToggleCard(
                  isDarkMode: isDark,
                  onChanged: (val) => themeNotifier.toggleDark(val),
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
                ContactUsCard(
                  onTap: () {
                    showDialog(
                      context: context,
                      // We don't want the user to accidentally dismiss it while typing or loading
                      barrierDismissible: false,
                      builder: (context) => const ContactUsOverlay(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                PaymentCard(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => const PaymentOverlay(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Expanded(child: const AboutUsCard()),
                const AboutUsCard(),
                const SizedBox(height: 16),
                LogoutCard(blocContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
