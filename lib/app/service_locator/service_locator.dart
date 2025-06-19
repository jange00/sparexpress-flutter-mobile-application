import 'package:get_it/get_it.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/auth/data/data_source/local_datasource/customer_local_data_source.dart';
import 'package:sparexpress/features/auth/data/repository/local_repository/customer_local_repository.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_get_current_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_image_upload_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_login_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_register_usecase.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  // await initApiModule();

  // Initialize all modules
  await _initAuthModule();
  await _initHomeModel();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

// Auth
Future <void> _initAuthModule() async {
  serviceLocator.registerLazySingleton<CustomerLocalDataSource>(
    () => CustomerLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerLazySingleton<CustomerLocalRepository>(
    () => CustomerLocalRepository(
      customerLocalDataSource: serviceLocator<CustomerLocalDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomerLoginUseCase>(
    () => CustomerLoginUseCase(
      customerRepository: serviceLocator<CustomerLocalRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomerRegisterUseCase>(
    () => CustomerRegisterUseCase(
      customerRepository: serviceLocator<CustomerLocalRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomerImageUploadUseCase>(
    () => CustomerImageUploadUseCase(
      customerRepository: serviceLocator<CustomerLocalRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomerGetCurrentUseCase>(
    () => CustomerGetCurrentUseCase(
      customerRepository: serviceLocator<CustomerLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      serviceLocator<CustomerRegisterUseCase>(),
      serviceLocator<CustomerImageUploadUseCase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<CustomerLoginUseCase>()),
  );
}

// Home
Future<void> _initHomeModel() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

// Splash
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
