import 'dart:async';
import 'dart:ffi';

import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/domain/usecase/home_usecase.dart';
import 'package:advance_flutter/presentation/base/baseviewmodel.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends Baseviewmodel
    implements HomeViewModelInput, HomeViewModelOutput {
       // hastakhdem " rxdart " el mara di
  // bdal ma a7ot .broadcast 3lshan y3mel listen 3la kol action gded by7sal
  // ha7ot behavior subject eli mn rxdart package w di fiha stream build-in fl package w by3mel listen 3la ay action gded
  // final StreamController _bannersStreamController =
  //     BehaviorSubject<List<BannersAd>>();
  // final StreamController _storesStreamController =
  //     BehaviorSubject<List<Stores>>();
  // final StreamController _servicesStreamController =
  //     BehaviorSubject<List<Services>>();

  // ? ha3mel refactor lel code w hakhli stream controller wahed bs shayel el class fiha el data kollaha
  final StreamController _dataStreamController =
      BehaviorSubject<HomeViewObject>();

  final HomeUsecase _homeUsecase;
  HomeViewModel(this._homeUsecase);

  // inputs
  @override
  void start() {
    _getHomeData();
  }

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRenderType: StateRendererType.fullScreenLoadingState));
    (await _homeUsecase.execute(Void)).fold(
        (failure) => {
              //left - > failure
              inputState.add(ErrorState(
                  StateRendererType.fullScreenErrorState, failure.message)),
            }, (homeObject) {
      //right -> success
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(homeObject.data.stores,
          homeObject.data.services, homeObject.data.banners));
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputHomeData => _dataStreamController.sink;

  //outputs

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInput {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutput {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;
  HomeViewObject(this.stores, this.services, this.banners);
}
