import 'package:advance_flutter/presentation/main/pages/home/view/home_page.dart';
import 'package:advance_flutter/presentation/main/pages/notifications/notifiations_page.dart';
import 'package:advance_flutter/presentation/main/pages/search/search_page.dart';
import 'package:advance_flutter/presentation/main/pages/settings/settings_page.dart';

import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    const HomePage(),
    const SearchPage(),
    const NotificationsPage(),
    const SettingsPage(),
  ];
  List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.search.tr(),
    AppStrings.notifications.tr(),
    AppStrings.settings.tr(),
  ];
  // var _title = AppStrings.home;
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: AppStrings.home.tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.search), label: AppStrings.search.tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: AppStrings.notifications.tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppStrings.settings.tr()),
        ],
        selectedItemColor: ColorManager.primary,
        unselectedItemColor: ColorManager.grey,
        backgroundColor: ColorManager.white,
        currentIndex: _currentIndex,
        onTap: onTap,
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      // _title = titles[index];
    });
  }
}
