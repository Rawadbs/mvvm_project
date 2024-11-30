import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:advance_flutter/presentation/resources/values_manger.dart';
import 'package:advance_flutter/presentation/store_details/view_model/store_details_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({super.key});

  @override
  StoreDetailsViewState createState() => StoreDetailsViewState();
}

class StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _viewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          title: Text(
            AppStrings.suites.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          elevation: AppSize.s0,
          iconTheme: IconThemeData(
            //back button
            color: ColorManager.black,
          ),
          backgroundColor: ColorManager.white,
          centerTitle: true,
        ),
        // body: _getContentWidget());
        body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return Container(
              child: snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _viewModel.start();
                  }) ??
                  Container(),
            );
          },
        ));
  }

  Widget _getContentWidget() {
    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      color: ColorManager.white,
      child: SingleChildScrollView(
        child: StreamBuilder<StoreDetails>(
          stream: _viewModel.outputStoreDetails,
          builder: (context, snapshot) {
            return _getItems(snapshot.data);
          },
        ),
      ),
    ));
  }

  Widget _getItems(StoreDetails? storeDetails) {
    if (storeDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Image.network(
            storeDetails.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          )),
          _getSection(AppStrings.details.tr()),
          _getInfoText(storeDetails.details),
          _getSection(AppStrings.services.tr()),
          _getServicesList(storeDetails.services),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
        padding: const EdgeInsets.only(
            top: AppPadding.p12,
            left: AppPadding.p12,
            right: AppPadding.p12,
            bottom: AppPadding.p2),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium));
  }

  Widget _getInfoText(String info) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.s12),
      child: Text(info, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Widget _getServicesList(String services) {
    // تقسيم النص عند الشرطة وإزالة المسافات الزائدة
    List<String> servicesList =
        services.split('-').map((s) => s.trim()).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSize.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: servicesList.map((service) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSize.s4),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: ColorManager.primary, size: 20),
                const SizedBox(width: AppSize.s8),
                Expanded(
                  child: Text(
                    service.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
