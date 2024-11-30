import 'package:advance_flutter/app/constants.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRenderType();

  String getMessage();
}

// loading state {popup,full screen}
class LoadingState extends FlowState {
  StateRendererType stateRenderType;
  String? message;

  LoadingState(
      {required this.stateRenderType, String message = AppStrings.loading});
  @override
  String getMessage() => message ?? AppStrings.loading.tr();

  @override
  StateRendererType getStateRenderType() => stateRenderType;
}
// error state {popup,full screen}

class ErrorState extends FlowState {
  StateRendererType stateRenderType;
  String message;
  ErrorState(this.stateRenderType, this.message);
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRenderType() => stateRenderType;
}

class SuccessState extends FlowState {
  String message;
  SuccessState(this.message);
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRenderType() => StateRendererType.popupSuccess;
}

//conent state
class ContentState extends FlowState {
  ContentState();
  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRenderType() => StateRendererType.contentState;
}

//empty state
class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRenderType() =>
      StateRendererType.fullScreenEmptyState;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRenderType() == StateRendererType.popupLoadingState) {
            // show popup loading
            showPopup(context, getStateRenderType(), getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen loading state
            return StateRenderer(
                message: getMessage(),
                stateRendererType: getStateRenderType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRenderType() == StateRendererType.popupErrorState) {
            // show popup error
            showPopup(context, getStateRenderType(), getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen error state
            return StateRenderer(
                message: getMessage(),
                stateRendererType: getStateRenderType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRenderType(),
              message: getMessage(),
              retryActionFunction: () {});
        }
      case ContentState:
        {
          // dismissDialog(context);

          return contentScreenWidget;
        }
      case SuccessState:
        dismissDialog(context);
        showPopup(context, StateRendererType.popupSuccess, getMessage(),
            title: AppStrings.success.tr());

        return contentScreenWidget;

      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  }

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }
  // checking if there is two dialogs running at the same time

  _isCurrentDialogShowing(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).canPop();
  }
  // check if there is two dialogs running at the same time and close on of them for example loading and error pop up, close loading

  showPopup(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {})));
  }
}
