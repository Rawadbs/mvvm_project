import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/data/data_source/local_data_source.dart';
import 'package:advance_flutter/data/data_source/remote_data_source.dart';
import 'package:advance_flutter/data/network/app_api.dart';
import 'package:advance_flutter/data/network/dio_factory.dart';
import 'package:advance_flutter/data/network/network_info.dart';
import 'package:advance_flutter/data/repository/repository_impl.dart';
import 'package:advance_flutter/domain/repository/repository.dart';
import 'package:advance_flutter/domain/usecase/forgot_password_usecase.dart';
import 'package:advance_flutter/domain/usecase/home_usecase.dart';
import 'package:advance_flutter/domain/usecase/login_usecase.dart';
import 'package:advance_flutter/domain/usecase/register_usecase.dart';
import 'package:advance_flutter/domain/usecase/store_details_usecase.dart';
import 'package:advance_flutter/presentation/forgot_password/viewmodel/forgot_password_view_model.dart';
import 'package:advance_flutter/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advance_flutter/presentation/main/pages/home/viewmodel/home__viewmodel.dart';
import 'package:advance_flutter/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:advance_flutter/presentation/store_details/view_model/store_details_view_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // App module its a module we put all generic dependcies

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  //app prefs instance
  instance
      .registerLazySingleton<AppPrefrences>(() => AppPrefrences(instance()));

  // network info instance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImp(InternetConnectionChecker()));

  //dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();

  // app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));

  // local data source

  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  // App module its a module we put all generic dependcies
  if (!GetIt.I.isRegistered<LoginUsecase>()) {
    instance.registerFactory<LoginUsecase>(() => LoginUsecase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUsecase>()) {
    instance
        .registerFactory<RegisterUsecase>(() => RegisterUsecase(instance()));
    instance.registerFactory<RegisterViewmodel>(
        () => RegisterViewmodel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUsecase>()) {
    instance.registerFactory<HomeUsecase>(() => HomeUsecase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUsecase>()) {
    instance.registerFactory<StoreDetailsUsecase>(() => StoreDetailsUsecase(instance()));
    instance.registerFactory<StoreDetailsViewModel>(() => StoreDetailsViewModel(instance()));
  }
}
