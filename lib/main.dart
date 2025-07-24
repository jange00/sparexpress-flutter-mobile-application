import 'package:flutter/cupertino.dart';
import 'package:sparexpress/app/app.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:provider/provider.dart';
import 'package:sparexpress/features/home/presentation/widgets/account_profile/logout/proximity_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // init Hive service
  await HiveService().init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShakeLogoutProvider(),
      child: App(),
    ),
  );
}