import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/data/data_source/local_data_source.dart';
import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/langauge_manager.dart';
import 'package:advance_flutter/presentation/resources/routes_manager.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:advance_flutter/presentation/resources/values_manger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dart:math' as math;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPrefrences _appPrefrences = instance<AppPrefrences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          const SizedBox(
            height: AppSize.s40,
          ),
          Center(
            child: Text(
              AppStrings.settings.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: Text(
              AppStrings.changeLanguage.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              Icons.language,
              color: ColorManager.primary,
            ),
            trailing: Transform(
              transform: Matrix4.rotationX(isRtl() ? math.pi : 0),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: ColorManager.primary,
              ),
            ),
            onTap: () {
              _changeLanguage();
            },
          ),
          ListTile(
            title: Text(
              AppStrings.contactsUs.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              Icons.contact_emergency,
              color: ColorManager.primary,
            ),
            trailing: Transform(
              transform: Matrix4.rotationX(isRtl() ? math.pi : 0),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: ColorManager.primary,
              ),
            ),
            onTap: () {
              _contactUs();
            },
          ),
          ListTile(
            title: Text(
              AppStrings.inviteYourFriends.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              Icons.share,
              color: ColorManager.primary,
            ),
            trailing: Transform(
              transform: Matrix4.rotationX(isRtl() ? math.pi : 0),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: ColorManager.primary,
              ),
            ),
            onTap: () {
              _inviteFreinds();
            },
          ),
          ListTile(
            title: Text(
              AppStrings.logout.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            leading: Icon(
              Icons.logout,
              color: ColorManager.primary,
            ),
            trailing: Transform(
              transform: Matrix4.rotationX(isRtl() ? math.pi : 0),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: ColorManager.primary,
              ),
            ),
            onTap: () {
              _logOut();
            },
          ),
        ],
      ),
    );
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }

  _changeLanguage() {
    _appPrefrences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  _contactUs() {
    // Here you can contact us
  }
  _inviteFreinds() {
    // Here you can contact us
  }
  _logOut() {
    // Here you can log out

    _appPrefrences.logout();
    // clear cache of logged out user
    _localDataSource.clearCache();
    Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
  }
}
