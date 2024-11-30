import 'dart:async';

import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class Baseviewmodel extends BaseViewModelInputs
    implements BaseViewModelOutputs {
  //shared variables and function that will be used through any view model

  final StreamController _inputStreamController = BehaviorSubject<FlowState>();
  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStreamController.stream.map((flowState) => flowState);
  @override
  void dispose() {
    // kol dispose mawgod f viewModel zay el login kda hakhli y_call el super.dispose 3lshan yenafez el dispose() di el awel w b3d kda el dispose eli fl model

    _inputStreamController.close();
  }
}

abstract class BaseViewModelInputs {
  void start(); // start view model job

  void dispose(); // will be called when view model dies

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  //will be implemented later
  Stream<FlowState> get outputState;
}
