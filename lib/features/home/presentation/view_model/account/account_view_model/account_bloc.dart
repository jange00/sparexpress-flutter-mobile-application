import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'account_event.dart';
import 'account_state.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/app/shared_pref/token_shared_prefs.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final BuildContext context;
  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShakeTime;

  AccountBloc({required this.context}) : super(AccountInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
    on<ShakeDetected>(_onShakeDetected);
    _startListening();
  }

  void _startListening() {
    _subscription = accelerometerEvents.listen((event) {
      final accelerationSquared =
          event.x * event.x + event.y * event.y + event.z * event.z;
      const threshold = 20.0 * 20.0;

      final now = DateTime.now();
      if (accelerationSquared > threshold &&
          (_lastShakeTime == null ||
              now.difference(_lastShakeTime!).inMilliseconds > 1500)) {
        _lastShakeTime = now;
        add(ShakeDetected());
      }
    });
  }

 Future<void> _onLogoutRequested(
    LogoutRequested event, Emitter<AccountState> emit) async {
    // Directly clear token and emit logout, UI handles confirmation
    final tokenPrefs = serviceLocator<TokenSharedPrefs>();
    await tokenPrefs.clearToken();
    emit(LogoutConfirmed());
  }

  void _onShakeDetected(ShakeDetected event, Emitter<AccountState> emit) {
    add(LogoutRequested());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
