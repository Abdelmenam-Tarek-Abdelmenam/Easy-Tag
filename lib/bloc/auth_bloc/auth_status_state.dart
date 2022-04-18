part of "auth_status_bloc.dart";

enum AuthStatus {
  initial,
  submittingEmail,
  submittingGoogle,
  sendingConfirm,
  doneConfirm,
  successLogIn,
  successSignUp,
  error,
}

class AuthStates extends Equatable {
  final AuthStatus status;
  final bool changeUi;

  const AuthStates({required this.status, this.changeUi = false});

  factory AuthStates.initial() {
    return const AuthStates(status: AuthStatus.initial, changeUi: false);
  }

  @override
  List<Object?> get props => [status, changeUi];

  AuthStates copyWith(
      {AuthStatus? status, AppAdmin? user, bool changeUi = false}) {
    return AuthStates(
      status: status ?? this.status,
      changeUi: changeUi ? !this.changeUi : changeUi,
    );
  }
}
