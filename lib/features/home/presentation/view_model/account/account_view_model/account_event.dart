abstract class AccountEvent {}

class LogoutRequested extends AccountEvent {}

class ShakeDetected extends AccountEvent {}

class DeleteAccountRequested extends AccountEvent {
  final String userId;
  DeleteAccountRequested(this.userId);
}
