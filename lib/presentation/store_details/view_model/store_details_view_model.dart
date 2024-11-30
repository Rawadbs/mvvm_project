import 'dart:async';
import 'dart:ffi';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/domain/usecase/store_details_usecase.dart';
import 'package:advance_flutter/presentation/base/baseviewmodel.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends Baseviewmodel
    implements StoreDetailsViewModelInput, StoreDetailsViewModelOutput {
  final StreamController _storeDetailsStreamController =
      BehaviorSubject<StoreDetails>();

  final StoreDetailsUsecase storeDetailsUseCase;

  StoreDetailsViewModel(this.storeDetailsUseCase);

  @override
  start() {
    _loadData();
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputStoreDetails => _storeDetailsStreamController.sink;
//output
  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _storeDetailsStreamController.stream.map((stores) => stores);
  _loadData() async {
    inputState.add(LoadingState(
        stateRenderType: StateRendererType.fullScreenLoadingState));
    (await storeDetailsUseCase.execute(Void)).fold(
      (failure) => {
        inputState.add(ErrorState(
            StateRendererType.fullScreenErrorState, failure.message)),
      },
      (storeDetails) async => {
        inputState.add(ContentState()),
        inputStoreDetails.add(storeDetails),
      },
    );
  }
}

abstract class StoreDetailsViewModelInput {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutput {
  Stream<StoreDetails> get outputStoreDetails;
}
