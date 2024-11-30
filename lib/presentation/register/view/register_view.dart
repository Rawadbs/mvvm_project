import 'dart:io';

import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/app/constants.dart';
import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:advance_flutter/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:advance_flutter/presentation/resources/assets_manager.dart';
import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/routes_manager.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:advance_flutter/presentation/resources/values_manger.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

bool _isHidden = true;

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewmodel _viewModel = instance<RegisterViewmodel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPrefrences _appPreferences = instance<AppPrefrences>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberEditingController =
      TextEditingController();
  _bind() {
    _viewModel.start();
    _userNameEditingController.addListener(() {
      _viewModel.setUserName(_userNameEditingController.text);
    });
    _emailEditingController.addListener(() {
      _viewModel.setEmail(_emailEditingController.text);
    });

    _passwordEditingController.addListener(() {
      _viewModel.setPassword(_passwordEditingController.text);
    });

    _mobileNumberEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberEditingController.text);
    });
    _viewModel.isUerRegisterSuccsuessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
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
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.register();
                }) ??
                _getContentWidget(); //if snapshot is not null, use snapshot data
          }),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p2),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage(
                    ImageAssets.splashLogo,
                  ),
                  width: AppSize.s250,
                ),
              ),
              Text(
                AppStrings.signup.tr(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppSize.s20),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorUserName,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _userNameEditingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: AppStrings.username.tr(),
                            labelText: AppStrings.username.tr(),
                            prefixIcon: const Icon(Icons.person_2_outlined),
                            prefixIconColor: ColorManager.black1,
                            filled: true,
                            errorText: snapshot.data),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s18),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CountryCodePicker(
                          onChanged: (country) {
                            _viewModel.setCountryCode(
                                country.dialCode ?? Constants.token);
                          },
                          initialSelection: '+966',
                          favorite: const ['+966', '+20'],
                          showCountryOnly: true,
                          hideMainText: true,
                          showOnlyCountryWhenClosed: true,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: StreamBuilder<String?>(
                            stream: _viewModel.outputErrorMobileNumber,
                            builder: (context, snapshot) {
                              return TextFormField(
                                  controller: _mobileNumberEditingController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      hintText: AppStrings.mobilenumber.tr(),
                                      labelText: AppStrings.mobilenumber.tr(),
                                      prefixIcon:
                                          const Icon(Icons.phone_outlined),
                                      prefixIconColor: ColorManager.black1,
                                      filled: true,
                                      errorText: (snapshot.data)));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s18),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorEmail,
                    builder: (context, snapshot) {
                      return TextFormField(
                          controller: _emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: AppStrings.emailHint.tr(),
                              labelText: AppStrings.emailHint.tr(),
                              prefixIcon: const Icon(Icons.email_outlined),
                              prefixIconColor: ColorManager.black1,
                              filled: true,
                              errorText: (snapshot.data)));
                    }),
              ),
              const SizedBox(height: AppSize.s18),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorPassword,
                    builder: (context, snapshot) {
                      return TextFormField(
                          controller: _passwordEditingController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: AppStrings.password.tr(),
                              labelText: AppStrings.password.tr(),
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
                              filled: true,
                              errorText: (snapshot.data)));
                    }),
              ),
              const SizedBox(height: AppSize.s18),
              Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: Container(
                    height: AppSize.s40,
                    decoration: BoxDecoration(
                      color: ColorManager.lightGrey1,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppSize.s8)),
                    ),
                    child: GestureDetector(
                      child: _getMediaWidget(),
                      onTap: () {
                        _showPicker(context);
                      },
                    ),
                  )),
              const SizedBox(height: AppSize.s40),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outputAllInputsValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.register();
                                }
                              : null,
                          child: Text(
                            AppStrings.register.tr(),
                            style: TextStyle(color: ColorManager.white),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: AppSize.s8),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p20,
                    right: AppPadding.p20,
                    top: AppPadding.p18),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.alreadyHaveAccount.tr(),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: ColorManager.lightGrey1,
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(
                  Icons.camera,
                ),
                title:  Text(AppStrings.photoGallery.tr()),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(
                  Icons.camera_alt_outlined,
                ),
                title:  Text(AppStrings.photoCamera.tr()),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ''));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ''));
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppPadding.p8,
        right: AppPadding.p8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Flexible(
            child: Text(AppStrings.profilePicture.tr()),
          ),
          Flexible(
              child: StreamBuilder<File>(
                  stream: _viewModel.outputProfilePicture,
                  builder: (context, snapshot) {
                    return _imagePickedByUser(snapshot.data);
                  })),
          Flexible(
            child: Icon(
              Icons.camera_alt_sharp,
              color: ColorManager.black1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(
        image,
      );
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}