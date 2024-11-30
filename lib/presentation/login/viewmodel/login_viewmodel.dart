import 'dart:async';

import 'package:advance_flutter/domain/usecase/login_usecase.dart';
import 'package:advance_flutter/presentation/base/baseviewmodel.dart';
import 'package:advance_flutter/presentation/common/freezed_data_classes.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';

class LoginViewModel extends Baseviewmodel
    implements LoginViewmodelInputs, LoginViewmodelOutputs {
  final StreamController _userNamestreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordstreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  final StreamController isUerLoginSuccsuessfullyStreamController =
      StreamController<bool>();

  var loginObject = LoginObject('', '');
  final LoginUsecase _loginUsecase;
  LoginViewModel(this._loginUsecase);
  //inputs
  @override
  void dispose() {
    super.dispose();
    _userNamestreamController.close();
    _passwordstreamController.close();
    _areAllInputsValidStreamController.close();
    isUerLoginSuccsuessfullyStreamController.close();
  }

  @override
  void start() {
    // view model should tell view please show content state
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordstreamController.sink;

  @override
  Sink get inputUserName => _userNamestreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllInputsValid.add(null);
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRenderType: StateRendererType.popupLoadingState));
    (await _loginUsecase.execute(
            LoginUsecaseInput(loginObject.userName, loginObject.password)))
        .fold(
            (failure) => {
                  //left - > failure
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message)),
                }, (data) {
      //right -> success
      inputState.add(ContentState());
      isUerLoginSuccsuessfullyStreamController.add(true);
    });
  }

  //outputs
  @override
  Stream<bool> get outIsPasswordValid => _passwordstreamController.stream
      .map((password) => _isPaswordValid(password));

  @override
  Stream<bool> get outIsUserNameValid => _userNamestreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _isUserNameValid(String username) {
    return username.isNotEmpty;
  }

  bool _isPaswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isUserNameValid(loginObject.userName) &&
        _isPaswordValid(loginObject.password);
  }
}

abstract class LoginViewmodelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();
  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputAreAllInputsValid;
}

abstract class LoginViewmodelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputsValid;
}
