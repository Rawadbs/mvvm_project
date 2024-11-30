import 'dart:async';
import 'dart:io';

import 'package:advance_flutter/app/functions.dart';
import 'package:advance_flutter/domain/usecase/register_usecase.dart';
import 'package:advance_flutter/presentation/base/baseviewmodel.dart';
import 'package:advance_flutter/presentation/common/freezed_data_classes.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterViewmodel extends Baseviewmodel
    implements RegisterViewModelInput, RegisterViewModelOutput {
  StreamController userNamestreamController =
      StreamController<String>.broadcast();
  StreamController mobileNumberStreamController =
      StreamController<String>.broadcast();
  StreamController emailStreamController = StreamController<String>.broadcast();
  StreamController passwordStreamController =
      StreamController<String>.broadcast();
  StreamController profilePicureStreamController =
      StreamController<File>.broadcast();
  StreamController areAllInputsValidstreamController =
      StreamController<void>.broadcast();
  final StreamController isUerRegisterSuccsuessfullyStreamController =
      StreamController<bool>();
  final RegisterUsecase _registerUsecase;
  var registerObject = RegisterObject('', '', '', '', '', '');
  RegisterViewmodel(this._registerUsecase);

//inputs

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    userNamestreamController.close();
    mobileNumberStreamController.close();
    emailStreamController.close();
    passwordStreamController.close();
    profilePicureStreamController.close();
    areAllInputsValidstreamController.close();
    isUerRegisterSuccsuessfullyStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputEmail => emailStreamController.sink;

  @override
  Sink get inputMobileNumber => mobileNumberStreamController.sink;

  @override
  Sink get inputPassword => passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => profilePicureStreamController.sink;

  @override
  Sink get inputUserName => userNamestreamController.sink;

  @override
  Sink get inputAllInputsValid => areAllInputsValidstreamController.sink;

  @override
  register() async {
    inputState.add(
        LoadingState(stateRenderType: StateRendererType.popupLoadingState));
    (await _registerUsecase.execute(RegisterUsecaseInput(
            registerObject.userName,
            registerObject.countryMobileCode,
            registerObject.mobileNumber,
            registerObject.email,
            registerObject.password,
            registerObject.profilePicture)))
        .fold(
            (failure) => {
                  //left - > failure
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message)),
                }, (data) {
      //right -> success
      inputState.add(ContentState());
      isUerRegisterSuccsuessfullyStreamController.add(true);
    });
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      //  update register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(userName: "");
    }
    validate();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      //  update register view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // reset code value in register view object
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      //  update register view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset email value in register view object
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_ismobileNumbuerValid(mobileNumber)) {
      //  update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset mobileNumber value in register view object
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      //  update register view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset password value in register view object
      registerObject = registerObject.copyWith(password: "");
    }
    validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      //  update register view object
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset profilePicture value in register view object
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    validate();
  }

//outputs

  @override
  Stream<bool> get outputUserNameValid => userNamestreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outputErrorUserName => outputUserNameValid
      .map((isUserName) => isUserName ? null : AppStrings.userNameInvalid.tr());

  @override
  Stream<bool> get outputEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.emailInvalid.tr());

  @override
  Stream<bool> get outputMobileNumberValid =>
      mobileNumberStreamController.stream
          .map((mobilenumber) => _ismobileNumbuerValid(mobilenumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputMobileNumberValid.map((ismobileNumbuerValid) =>
          ismobileNumbuerValid ? null : AppStrings.mobileNumberInvalid.tr());

  @override
  Stream<bool> get outputPasswordValid => passwordStreamController.stream
      .map((password) => _isPasswordValid(password));
  @override
  Stream<String?> get outputErrorPassword => outputPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.passwordInvalid.tr());

  @override
  Stream<File> get outputProfilePicture =>
      profilePicureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputAllInputsValid =>
      areAllInputsValidstreamController.stream.map((_) => _areAllInputsValid());

// - - - - private functions
  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _ismobileNumbuerValid(String mobilenumber) {
    return mobilenumber.length == 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.countryMobileCode.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  validate() {
    inputAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInput {
  Sink get inputUserName;
  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;
  register();
  setUserName(String userName);

  setMobileNumber(String mobileNumber);

  setCountryCode(String countryCode);

  setEmail(String email);

  setPassword(String password);

  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputUserNameValid;
  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<File> get outputProfilePicture;
  Stream<bool> get outputAllInputsValid;
}
