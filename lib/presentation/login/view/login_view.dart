import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:advance_flutter/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advance_flutter/presentation/resources/assets_manager.dart';
import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/routes_manager.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:advance_flutter/presentation/resources/values_manger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

bool _isHidden = true;

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _loginViewModel = instance<LoginViewModel>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPrefrences _appPrefrences = instance<AppPrefrences>();

  _bind() {
    _loginViewModel.start(); //tell viewmodel start ur job
    _userNameController.addListener(() => _loginViewModel.setUserName(
        _userNameController.text)); //update text field with data from viewmodel
    _userPasswordController.addListener(() => _loginViewModel.setPassword(
        _userPasswordController.text)); //update text field with data from view
    _loginViewModel.isUerLoginSuccsuessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPrefrences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRote);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
          stream: _loginViewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _loginViewModel.login();
                }) ??
                _getContentWidget(); //if snapshot is not null, use snapshot data
          }),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  ImageAssets.splashLogo,
                  width: AppSize.s250,
                ),
                // child: SvgPicture.asset(
                //   ImageAssets.login,
                //   width: 300,
                // ),
              ),
              Text(
                AppStrings.welcomeback.tr(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _loginViewModel.outIsUserNameValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                          controller: _userNameController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: AppStrings.username.tr(),
                              filled: true,
                              labelText: AppStrings.username.tr(),
                              prefixIcon: const Icon(Icons.email_outlined),
                              prefixIconColor: ColorManager.black1,
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.usernameError.tr()));
                    }),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _loginViewModel.outIsPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                          controller: _userPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                              hintText: AppStrings.password.tr(),
                              labelText: AppStrings.password.tr(),
                              filled: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                              prefixIconColor: ColorManager.black1,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ColorManager.black1,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isHidden = !_isHidden;
                                  });
                                },
                              ),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.passwordError.tr()));
                    }),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _loginViewModel.outAreAllInputsValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _loginViewModel.login();
                                }
                              : null,
                          child: Text(
                            AppStrings.login.tr(),
                            style: TextStyle(color: ColorManager.white),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s8),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p20, right: AppPadding.p20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.forgotpasswordRote);
                      },
                      child: Text(
                        AppStrings.forgetpassword.tr(),
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.registerRote);
                      },
                      child: Text(
                        AppStrings.signupText.tr(),
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }
}
