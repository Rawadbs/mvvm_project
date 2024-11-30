import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/presentation/forgot_password/view/forgot_password_view.dart';
import 'package:advance_flutter/presentation/login/view/login_view.dart';
import 'package:advance_flutter/presentation/main/main_view.dart';
import 'package:advance_flutter/presentation/onboarding/view/onboarding_view.dart';
import 'package:advance_flutter/presentation/register/view/register_view.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:advance_flutter/presentation/splash/splash_view.dart';
import 'package:advance_flutter/presentation/store_details/view/store_details_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Routes {
  static const String splashRote = '/';
  static const String loginRoute = '/login';
  static const String registerRote = '/register';
  static const String forgotpasswordRote = '/forgotPassword';
  static const String onBoarding = '/onBoarding';
  static const String mainRote = '/main';
  static const String storeDetailRoute = '/storeDetails';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRote:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (context) => const LoginView());
      case Routes.registerRote:
        initRegisterModule();
        return MaterialPageRoute(builder: (context) => const RegisterView());
      case Routes.forgotpasswordRote:
        initForgotPasswordModule();

        return MaterialPageRoute(
            builder: (context) => const ForgotPasswordView());
      case Routes.mainRote:
        initHomeModule();
        return MaterialPageRoute(builder: (context) => const MainView());
      case Routes.storeDetailRoute:
        initStoreDetailsModule();
        return MaterialPageRoute(
            builder: (context) => const StoreDetailsView());

      case Routes.onBoarding:
        return MaterialPageRoute(builder: (context) => const OnBoardingView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title:  Text(
            AppStrings.noRouteFound.tr(),
          ),
        ),
        body: Center(
          child:  Text(AppStrings.noRouteFound.tr()),
        ),
      ),
    );
  }
}
