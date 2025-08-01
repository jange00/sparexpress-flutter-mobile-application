import 'package:mocktail/mocktail.dart';
import 'package:sparexpress/features/auth/domain/repository/customer_repository.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';
import 'package:sparexpress/core/network/api_service.dart';
import 'package:sparexpress/features/auth/data/data_source/remote_datasource/customer_remote_datasource.dart';
import 'package:sparexpress/features/auth/data/repository/remote_repository/customer_remote_repository.dart';
import 'package:sparexpress/features/auth/data/repository/local_repository/customer_local_repository.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'package:sparexpress/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparexpress/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_register_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_login_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_image_upload_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_get_current_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_request_reset_usecase.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_reset_password_usecase.dart';

// Mock classes
class MockICustomerRepository extends Mock implements ICustomerRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}
class MockApiService extends Mock implements ApiService {}
class MockCustomerRemoteDatasource extends Mock implements CustomerRemoteDatasource {}
class MockCustomerRemoteRepository extends Mock implements CustomerRemoteRepository {}
class MockCustomerLocalRepository extends Mock implements CustomerLocalRepository {}
class MockCustomerRegisterUseCase extends Mock implements CustomerRegisterUseCase {}
class MockCustomerLoginUseCase extends Mock implements CustomerLoginUseCase {}
class MockCustomerImageUploadUseCase extends Mock implements CustomerImageUploadUseCase {}
class MockCustomerGetCurrentUseCase extends Mock implements CustomerGetCurrentUseCase {}
class MockCustomerRequestResetUseCase extends Mock implements CustomerRequestResetUseCase {}
class MockCustomerResetPasswordUseCase extends Mock implements CustomerResetPasswordUseCase {}
class MockRegisterViewModel extends Mock implements RegisterViewModel {}
class MockLoginViewModel extends Mock implements LoginViewModel {}

// Test data constants
class TestData {
  static const testCustomer = CustomerEntity(
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
    password: 'password123',
    profileImage: 'profile.jpg',
  );

  static const testCustomer2 = CustomerEntity(
    fullName: 'Jane Smith',
    email: 'jane@example.com',
    phoneNumber: '+0987654321',
    password: 'password456',
    profileImage: null,
  );

  static const testEmail = 'test@example.com';
  static const testPassword = 'password123';
  static const testToken = 'jwt_token_123';
  static const testFullName = 'John Doe';
  static const testPhoneNumber = '+1234567890';
  static const testProfileImage = 'profile.jpg';
  static const testResetToken = 'reset_token_123';

  // Test failures
  static const testFailure = RemoteDatabaseFailure(message: 'Test error message');
  static const networkFailure = RemoteDatabaseFailure(message: 'Network error');
  static const validationFailure = RemoteDatabaseFailure(message: 'Validation failed');
  static const authFailure = RemoteDatabaseFailure(message: 'Authentication failed');
  static const serverFailure = RemoteDatabaseFailure(message: 'Server error');
  static const timeoutFailure = RemoteDatabaseFailure(message: 'Request timeout');
}

// Test utilities
class TestUtils {
  static void setupMockTokenSharedPrefs(MockTokenSharedPrefs mock) {
    when(() => mock.saveToken(any())).thenAnswer((_) async => const Right(true));
    when(() => mock.getToken()).thenAnswer((_) async => const Right(TestData.testToken));
    when(() => mock.clearToken()).thenAnswer((_) async => const Right(true));
  }

  static void setupMockCustomerRepository(MockICustomerRepository mock) {
    when(() => mock.registerCustomer(any())).thenAnswer((_) async => const Right(null));
    when(() => mock.loginCustomer(any(), any())).thenAnswer((_) async => const Right(TestData.testToken));
    when(() => mock.getCurrentUser()).thenAnswer((_) async => Right(TestData.testCustomer));
    when(() => mock.uploadProfilePicture(any())).thenAnswer((_) async => const Right(TestData.testProfileImage));
    when(() => mock.requestPasswordReset(any())).thenAnswer((_) async => const Right(null));
    when(() => mock.resetPassword(any(), any())).thenAnswer((_) async => const Right(null));
  }

  static void setupMockRemoteDatasource(MockCustomerRemoteDatasource mock) {
    when(() => mock.registerCustomer(any())).thenAnswer((_) async {});
    when(() => mock.loginCustomer(any(), any())).thenAnswer((_) async => TestData.testToken);
    when(() => mock.getCurrentUser()).thenAnswer((_) async => TestData.testCustomer);
    when(() => mock.uploadProfilePicture(any())).thenAnswer((_) async => TestData.testProfileImage);
    when(() => mock.requestPasswordReset(any())).thenAnswer((_) async {});
    when(() => mock.resetPassword(any(), any())).thenAnswer((_) async {});
  }

  static void setupMockLocalRepository(MockCustomerLocalRepository mock) {
    when(() => mock.registerCustomer(any())).thenAnswer((_) async => const Right(null));
    when(() => mock.loginCustomer(any(), any())).thenAnswer((_) async => const Right(TestData.testToken));
    when(() => mock.getCurrentUser()).thenAnswer((_) async => Right(TestData.testCustomer));
    when(() => mock.uploadProfilePicture(any())).thenAnswer((_) async => const Right(TestData.testProfileImage));
    when(() => mock.requestPasswordReset(any())).thenAnswer((_) async => const Right(null));
    when(() => mock.resetPassword(any(), any())).thenAnswer((_) async => const Right(null));
  }

  static void setupMockUseCases({
    required MockCustomerRegisterUseCase registerUseCase,
    required MockCustomerLoginUseCase loginUseCase,
    required MockCustomerImageUploadUseCase uploadUseCase,
    required MockCustomerGetCurrentUseCase getCurrentUseCase,
    required MockCustomerRequestResetUseCase requestResetUseCase,
    required MockCustomerResetPasswordUseCase resetPasswordUseCase,
  }) {
    when(() => registerUseCase(any())).thenAnswer((_) async => const Right(null));
    when(() => loginUseCase(any())).thenAnswer((_) async => const Right(TestData.testToken));
    when(() => uploadUseCase(any())).thenAnswer((_) async => const Right(TestData.testProfileImage));
    when(() => getCurrentUseCase()).thenAnswer((_) async => Right(TestData.testCustomer));
    when(() => requestResetUseCase(any())).thenAnswer((_) async => const Right(null));
    when(() => resetPasswordUseCase(any())).thenAnswer((_) async => const Right(null));
  }

  // Widget test helpers
  static Widget createTestApp({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  static Widget createTestAppWithBloc<T extends BlocBase>({
    required T bloc,
    required Widget child,
  }) {
    return MaterialApp(
      home: BlocProvider<T>.value(
        value: bloc,
        child: child,
      ),
    );
  }
} 