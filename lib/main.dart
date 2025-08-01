import 'package:flutter/cupertino.dart';
import 'package:sparexpress/app/app.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:provider/provider.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/logout/proximity_provider.dart';
import 'package:sparexpress/core/common/internet_checker/global_connectivity_banner.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // init Hive service
  await HiveService().init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShakeLogoutProvider(),
      child: AppWithBanner(),
    ),
  );
}

// Add this widget to wrap MaterialApp with the banner using the builder property
class AppWithBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return App(
      builder: (context, child) => GlobalConnectivityBanner(child: child!),
    );
  }
}