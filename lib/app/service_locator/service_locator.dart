import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
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
import 'package:sparexpress/features/home/data/data_source/remote_datasource/cart_remote_data_source.dart';
// import 'package:sparexpress/features/home/data/data_source/local_datasource/category_local_data_source.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/category_remote_data_source.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/order_remote_data_source.dart';
// import 'package:sparexpress/features/home/data/data_source/local_datasource/product_local_data_source.dart';
import 'package:sparexpress/features/home/data/data_source/remote_datasource/product_remote_data_source.dart';
// import 'package:sparexpress/features/home/data/repository/local_repository/cart_local_repository.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/cart_remote_repostiory.dart';
// import 'package:sparexpress/features/home/data/repository/local_repository/category_local_repository.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/category_remote_repository.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/order_remote_repository.dart';
import 'package:sparexpress/features/home/data/repository/remote_repository/product_remote_repository.dart';
import 'package:sparexpress/features/home/domin/repository/cart_repository.dart';
import 'package:sparexpress/features/home/domin/repository/category_repository.dart';
import 'package:sparexpress/features/home/domin/repository/products_repository.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/get_all_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/get-all_category_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/get_all_product_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/create_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/order/get_all_order_usecase.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/category_view_model/category_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/dicounted_products_view_model/offer_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/dashboard/product_view_model/product_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/order/order_view_model/order_bloc.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await initApiModule();
  await  _initSharedPrefs();
  await _initAuthModule();
  await _initHomeModel();
  await _initSplashModule();
  await _initProductModule();
  await _initCategoryModule();
  await _initCartModule();
  await _initOrderModule();
  // Dashboard Profile Header
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> initApiModule() async {
  // Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

Future <void> _initSharedPrefs() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
  ),
  );
}


// Auth
Future <void> _initAuthModule() async {
  serviceLocator.registerLazySingleton<CustomerLocalDataSource>(
    () => CustomerLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

//
  serviceLocator.registerFactory(() => CustomerRemoteDatasource(apiservice: serviceLocator<ApiService>(),tokenSharedPrefs:serviceLocator<TokenSharedPrefs>() ));

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
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
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

// Cart
Future<void> _initCartModule() async {
  // Remote Data Source
  serviceLocator.registerFactory<CartRemoteDataSource>(
    () => CartRemoteDataSource(apiService: serviceLocator<ApiService>(),tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );

  // Repository
  serviceLocator.registerFactory<CartRemoteRepository>(
    () => CartRemoteRepository(cartRemoteDataSource: serviceLocator<CartRemoteDataSource>()),
  );

  // UseCase
  serviceLocator.registerFactory<GetAllCartUsecase>(
    () => GetAllCartUsecase(cartRepository: serviceLocator<CartRemoteRepository>()),
  );
  serviceLocator.registerFactory<CreateCartUsecase>(
    () => CreateCartUsecase(cartRepository: serviceLocator<CartRemoteRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory<CartBloc>(
    () => CartBloc(
      getAllCartUsecase: serviceLocator<GetAllCartUsecase>(),
      createCartUsecase: serviceLocator<CreateCartUsecase>(),
    ),
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

// Order
Future<void> _initOrderModule() async {
  // Remote Data Source
  serviceLocator.registerFactory<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<OrderRemoteRepository>(
    () => OrderRemoteRepository(
      orderRemoteDataSource: serviceLocator<OrderRemoteDataSource>(),
    ),
  );

  // UseCases
  serviceLocator.registerFactory<GetAllOrderUsecase>(
    () => GetAllOrderUsecase(
      repository: serviceLocator<OrderRemoteRepository>(),
    ),
  );

  // Bloc
  serviceLocator.registerFactory<OrderBloc>(
    () => OrderBloc(
      getAllOrderUsecase: serviceLocator<GetAllOrderUsecase>(),
    ),
  );
}





// Splash
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()));
}
