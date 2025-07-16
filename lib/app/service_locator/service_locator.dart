import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/core/network/hive_service.dart';
import 'package:sparexpress/features/auth/data/data_source/local_datasource/customer_local_data_source.dart';
import 'package:sparexpress/features/auth/data/data_source/remote_datasource/customer_remote_datasource.dart';
import 'package:sparexpress/features/auth/data/repository/local_repository/customer_local_repository.dart';
import 'package:sparexpress/features/auth/data/repository/remote_repository/customer_remote_repository.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_get_current_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_image_upload_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_login_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_register_usecase.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
// import 'package:sparexpress/features/home/data/data_source/local_datasource/category_local_data_source.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/category_remote_data_source.dart';
// import 'package:sparexpress/features/home/data/data_source/local_datasource/product_local_data_source.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/product_remote_data_source.dart';
// import 'package:sparexpress/features/home/data/repository/local_repository/category_local_repository.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/category_remote_repository.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/product_remote_repository.dart';
import 'package:sparexpress/features/home/domin/repository/category_repository.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';
import 'package:sparexpress/features/home/domin/use_case/get-all_category_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/category_view_model/category_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await initApiModule();

  // Initialize all modules
  await _initAuthModule();
  await _initHomeModel();
  await _initSplashModule();
  await _initProductModule();
  await _initCategoryModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> initApiModule() async {
  // Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}


// Auth
Future <void> _initAuthModule() async {
  serviceLocator.registerLazySingleton<CustomerLocalDataSource>(
    () => CustomerLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

//
  serviceLocator.registerFactory(() => CustomerRemoteDatasource(apiservice: serviceLocator<ApiService>()));

  serviceLocator.registerLazySingleton<CustomerLocalRepository>(
    () => CustomerLocalRepository(
      customerLocalDataSource: serviceLocator<CustomerLocalDataSource>(),
    ),
  );

//
  serviceLocator.registerFactory(() => CustomerRemoteRepository(datasource: serviceLocator<CustomerRemoteDatasource>()));

  serviceLocator.registerLazySingleton<CustomerLoginUseCase>(
    () => CustomerLoginUseCase(
      customerRepository: serviceLocator<CustomerRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomerRegisterUseCase>(
    () => CustomerRegisterUseCase(
      customerRepository: serviceLocator<CustomerRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomerImageUploadUseCase>(
    () => CustomerImageUploadUseCase(
      customerRepository: serviceLocator<CustomerRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomerGetCurrentUseCase>(
    () => CustomerGetCurrentUseCase(
      customerRepository: serviceLocator<CustomerRemoteRepository>(),
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
  
  // Profile account
  serviceLocator.registerFactory(() => ProfileBloc(
  getCurrentCustomer: serviceLocator<CustomerGetCurrentUseCase>(),
));
}

// Home
Future<void> _initHomeModel() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

// Product
Future<void> _initProductModule() async {
  // Remote Data Source
serviceLocator.registerFactory<ProductRemoteDataSource>(
  () => ProductRemoteDataSource(apiService: serviceLocator<ApiService>()),
);

// Repository
serviceLocator.registerFactory<IProductRepository>(
  () => ProductRemoteRepository(productRemoteDataSource: serviceLocator<ProductRemoteDataSource>()),
);

// UseCase
serviceLocator.registerFactory<GetAllProductUsecase>(
  () => GetAllProductUsecase(productRepository: serviceLocator<IProductRepository>()),
);

// Bloc
serviceLocator.registerFactory<ProductBloc>(
  () => ProductBloc(getAllProducts: serviceLocator<GetAllProductUsecase>()),
);

// offer products
serviceLocator.registerFactory<OfferBloc>(
  () => OfferBloc(getAllProductUsecase: serviceLocator<GetAllProductUsecase>()),
);
}


Future<void> _initCategoryModule() async {
  // Remote Data Source
  serviceLocator.registerFactory<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerFactory<ICategoryRepository>(
    () => CategoryRemoteRepository(
      categoryRemoteDataSource: serviceLocator<CategoryRemoteDataSource>(),
    ),
  );

  // Use Case - Get only
  serviceLocator.registerFactory<GetAllCategoryUsecase>(
    () => GetAllCategoryUsecase(
      categoryRepository: serviceLocator<ICategoryRepository>(),
    ),
  );

  // Bloc
  serviceLocator.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      getAllCategoryUsecase: serviceLocator<GetAllCategoryUsecase>(),
    ),
  );
}




// Splash
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
