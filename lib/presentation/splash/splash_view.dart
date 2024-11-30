import 'dart:async';

import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/presentation/resources/assets_manager.dart';
import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/constants_manager.dart';
import 'package:advance_flutter/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPrefrences _appPrefrences = instance<AppPrefrences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    _appPrefrences.isUserLoggedIn().then((isUserLoggedIn) => {
          if (isUserLoggedIn)
            {Navigator.pushReplacementNamed(context, Routes.mainRote)}
          else
            {
              _appPrefrences
                  .isOnboardingScreenViewed()
                  .then((isOnboardingScreenViewed) => {
                        if (isOnboardingScreenViewed)
                          {
                            Navigator.pushReplacementNamed(
                                context, Routes.loginRoute)
                          }
                        else
                          {
                            Navigator.pushReplacementNamed(
                                context, Routes.onBoarding)
                          }
                      })
            }
        });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: const Center(
        child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        ),
        
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
