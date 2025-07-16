import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'account_event.dart';
import 'account_state.dart';

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
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("Confirm Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC107),
            foregroundColor: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Logout"),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    emit(LogoutConfirmed());
    // DO NOT navigate here
  } else {
    emit(AccountInitial());
  }
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
