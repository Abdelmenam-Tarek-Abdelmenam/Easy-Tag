import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/app_admin.dart';
import '../../model/repository/auth_repository.dart';
import '../../view/shared/widgets/toast_helper.dart';

part 'auth_status_event.dart';
part 'auth_status_state.dart';

class AuthStatusBloc extends Bloc<AuthStatusEvent, AuthStates> {
  final AuthRepository _authRepository = AuthRepository();

  AppAdmin get user => _authRepository.currUser;

  AuthStatusBloc() : super(AuthStates.initial()) {
    on<LoginInUsingGoogleEvent>(_loginUsingGoogleHandler);
    on<SignUpInUsingEmailEvent>(_signUpUsingEmailHandler);
    on<ChangeSomeUiEvent>(_changeUiHandler);
    on<LoginInUsingEmailEvent>(_loginUsingEmailHandler);
    on<ForgetPasswordEvent>(_forgetPasswordHandler);
  }

  void _changeUiHandler(
    ChangeSomeUiEvent event,
    Emitter<AuthStates> emit,
  ) {
    emit(state.copyWith(changeUi: true));
  }

  Future<void> _loginUsingGoogleHandler(
    LoginInUsingGoogleEvent event,
    Emitter<AuthStates> emit,
  ) async {
    if ([AuthStatus.submittingEmail, AuthStatus.submittingGoogle]
        .contains(state.status)) {
      return;
    }
    emit(state.copyWith(status: AuthStatus.submittingGoogle));
    try {
      await _authRepository.signInUsingGoogle();
      emit(state.copyWith(status: AuthStatus.successLogIn));
    } on FireBaseAuthErrors catch (e) {
      showToast(e.message);
      emit(
        state.copyWith(status: AuthStatus.error),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error),
      );
    }
  }

  Future<void> _loginUsingEmailHandler(
    LoginInUsingEmailEvent event,
    Emitter<AuthStates> emit,
  ) async {
    if ([AuthStatus.submittingEmail, AuthStatus.submittingGoogle]
        .contains(state.status)) {
      return;
    }
    emit(state.copyWith(status: AuthStatus.submittingEmail));

    try {
      await _authRepository.signInWithEmailAndPassword(
          event.email, event.password);
      emit(state.copyWith(status: AuthStatus.successLogIn));
    } on FireBaseAuthErrors catch (e) {
      showToast(e.message, type: ToastType.error);
      emit(state.copyWith(status: AuthStatus.error));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> _signUpUsingEmailHandler(
    SignUpInUsingEmailEvent event,
    Emitter<AuthStates> emit,
  ) async {
    if ([AuthStatus.submittingEmail, AuthStatus.submittingGoogle]
        .contains(state.status)) {
      return;
    }
    emit(state.copyWith(status: AuthStatus.submittingEmail));

    try {
      await _authRepository.signUpWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(state.copyWith(status: AuthStatus.successSignUp));
    } on FireBaseAuthErrors catch (e) {
      showToast(e.message, type: ToastType.error);
      emit(state.copyWith(status: AuthStatus.error));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> _forgetPasswordHandler(
    ForgetPasswordEvent event,
    Emitter<AuthStates> emit,
  ) async {
    if (AuthStatus.sendingConfirm == state.status) {
      return;
    }
    emit(state.copyWith(status: AuthStatus.sendingConfirm));
    showToast("Password reset email sent to you", type: ToastType.info);
    try {
      await _authRepository.forgetPassword(event.email);
      emit(state.copyWith(status: AuthStatus.doneConfirm));
    } on FireBaseAuthErrors catch (e) {
      showToast(e.message, type: ToastType.error);
      emit(state.copyWith(status: AuthStatus.error));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}
