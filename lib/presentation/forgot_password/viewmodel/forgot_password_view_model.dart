import 'dart:async';

import 'package:advance_flutter/app/functions.dart';
import 'package:advance_flutter/domain/usecase/forgot_password_usecase.dart';
import 'package:advance_flutter/presentation/base/baseviewmodel.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';

class ForgotPasswordViewModel extends Baseviewmodel
    implements ForgotPasswordViewModelInput, ForgotPasswordViewModelOutput {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  var email = "";

  // input
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRenderType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold((failure) {
      inputState
          .add(ErrorState(StateRendererType.popupErrorState, failure.message));
    }, (supportMessage) {
      inputState.add(SuccessState(supportMessage));
    });
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  // output
  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputValidStreamController.stream
          .map((isAllInputValid) => _isAllInputValid());

  _isAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }
}

abstract class ForgotPasswordViewModelInput {
  forgotPassword();

  setEmail(String email);

  Sink get inputEmail;

  Sink get inputIsAllInputValid;
}

abstract class ForgotPasswordViewModelOutput {
  Stream<bool> get outputIsEmailValid;

  Stream<bool> get outputIsAllInputValid;
}
