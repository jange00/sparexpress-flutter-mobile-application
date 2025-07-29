abstract class AccountState {}

class AccountInitial extends AccountState {}

class LogoutConfirmed extends AccountState {}

class AccountDeleteSuccess extends AccountState {}
class AccountDeleteFailure extends AccountState {
  final String message;
  AccountDeleteFailure(this.message);
}
