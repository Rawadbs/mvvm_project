import 'dart:async';

import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/presentation/base/baseviewmodel.dart';
import 'package:advance_flutter/presentation/resources/assets_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../resources/strings_manager.dart';

class OnboardingViewmodel extends Baseviewmodel
    implements OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  //stream controllers outputs
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  late final List<SliderObject> _list;
  int _currentPageIndex = 0;
  int get currentIndex => _currentPageIndex;

  // OnBoarding ViewModel Inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    // viewmodel start your job
    _list = _getSliderData();
    _postDataToView();
  }

  @override
  int goNext() {
    int nextIndex = ++_currentPageIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentPageIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int value) {
    _currentPageIndex = value;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  // OnBoarding ViewModel OutPuts

  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map(
        (sliderViewObject) => sliderViewObject,
      );

  // onboarding private functions
  void _postDataToView() {
    inputSliderViewObject.add(SliderViewObject(
        _list[_currentPageIndex], _list.length, _currentPageIndex));
  }

  List<SliderObject> _getSliderData() => [
        SliderObject(AppStrings.onBoadingTitle1.tr(), AppStrings.onBoadingSubTitle1.tr(),
            ImageAssets.onboardingLogo1),
        SliderObject(AppStrings.onBoadingTitle2.tr(), AppStrings.onBoadingSubTitle2.tr(),
            ImageAssets.onboardingLogo2),
        SliderObject(AppStrings.onBoadingTitle3.tr(), AppStrings.onBoadingSubTitle3.tr(),
            ImageAssets.onboardingLogo3),
      ];
}

class TestViewModel extends Baseviewmodel {
  @override
  void dispose() {}

  @override
  void start() {
    //call detail api
  }
}

// inputs mean that "Orders" that our view model will receive from view
abstract class OnBoardingViewModelInputs {
  int goNext(); //when user click on right arrow or swipe left
  int goPrevious(); //when user click on left arrow or swipe right
  void onPageChanged(int value);

  // stream controller input
  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  // stream controller output

  Stream<SliderViewObject> get outputSliderViewObject;
}
