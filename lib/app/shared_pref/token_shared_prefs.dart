import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparexpress/core/error/failure.dart';

class TokenSharedPrefs {
  late SharedPreferences _sharedPreferences;

  TokenSharedPrefs({required SharedPreferences sharedPreferences})
  : _sharedPreferences  = sharedPreferences;


  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  // 

  Future<Either<Failure, bool >> saveToken(String token) async {
    try{
        _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('token', token);
      return right(true);
    }catch(e) {
      return Left(SharedPreferencesFailure(message: 'Failed to save token: $e'),
      );
    }
  }

  Future<Either<Failure, String? >> getToken() async {
    try{
      _sharedPreferences = await SharedPreferences.getInstance();
      final token = _sharedPreferences.getString('token');
      return right(token);
    }catch(e) {
      return Left(SharedPreferencesFailure(message: 'Failed to retrieve token: $e'),
      );
    }
  }
}