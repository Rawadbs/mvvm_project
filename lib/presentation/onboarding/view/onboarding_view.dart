import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/presentation/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:advance_flutter/presentation/resources/assets_manager.dart';
import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/constants_manager.dart';
import 'package:advance_flutter/presentation/resources/routes_manager.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:advance_flutter/presentation/resources/values_manger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  final OnboardingViewmodel _viewmodel = OnboardingViewmodel();
  final AppPrefrences _appPrefrences = instance<AppPrefrences>();

  _bind() {
    _appPrefrences.setisOnboardingScreenViewed();

    _viewmodel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream: _viewmodel.outputSliderViewObject,
        builder: (context, snapshot) {
          return _getContentWidget(snapshot.data);
        });
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, value) {
                return OnBoardingPage(sliderViewObject.sliderObject);
              },
              controller: _pageController,
              itemCount: sliderViewObject.numOfSLides,
              onPageChanged: (value) {
                _viewmodel.onPageChanged(value);
              },
            ),
            // Adding the bottom sheet inside the Stack
            Positioned(
              bottom: 0,
              child: _getBottomSheetWidget(sliderViewObject),
            ),
          ],
        ),
      );
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: Colors.transparent, // Remove the background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left row (السهم الأيسر)
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SvgPicture.asset(ImageAssets.leftArrowIc),
              onTap: () {
                // الانتقال إلى الشريحة السابقة
                _pageController.animateToPage(_viewmodel.goPrevious(),
                    duration: const Duration(
                        milliseconds: AppConstants.sliderAnimationTime),
                    curve: Curves.bounceInOut);
              },
            ),
          ),
          // circle indicator (مؤشر الدائرة)
          Row(
            children: [
              for (int i = 0; i < sliderViewObject.numOfSLides; i++)
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, sliderViewObject.currentIndex),
                ),
            ],
          ),
          // Right arrow (السهم الأيمن)
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                width: AppSize.s20,
                height: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.rightArrowIc),
              ),
              onTap: () {
                // تحقق إذا كان المستخدم في الصفحة الأخيرة
                if (_viewmodel.currentIndex ==
                    sliderViewObject.numOfSLides - 1) {
                  // الانتقال إلى صفحة تسجيل الدخول
                  Navigator.pushReplacementNamed(context, Routes.loginRoute);
                } else {
                  // الانتقال إلى الشريحة التالية
                  int nextIndex = _viewmodel.goNext();
                  _pageController.animateToPage(
                    nextIndex,
                    duration: const Duration(
                        milliseconds: AppConstants.sliderAnimationTime),
                    curve: Curves.bounceInOut,
                  );
                }
              },
            ),
          ),

          const SizedBox(
            width: AppSize.s160,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.loginRoute);
            },
            child: Text(
              AppStrings.skip.tr(),
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProperCircle(int value, int currenIndex) {
    if (value == currenIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircleIc);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircleIc);
    }
  }

  @override
  void dispose() {
    _viewmodel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;

  const OnBoardingPage(this._sliderObject, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الصورة مع التأثير الداكن
        Positioned.fill(
          child: Image.asset(
            _sliderObject.image,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: ColorManager.black.withOpacity(0.5),
            gaplessPlayback: true, // يضمن التحميل المستمر دون وميض
// شفافية داكنة
          ),
        ),
        // النصوص فوق الصورة
        Positioned(
          bottom: AppSize.s90, // تحريك النصوص لتكون أقرب من الأسفل
          right: 0,
          left: 5,
          child: Center(
            child: Column(
              children: [
                Text(_sliderObject.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall),
                Text(_sliderObject.subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
