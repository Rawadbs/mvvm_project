import 'package:advance_flutter/presentation/resources/langauge_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_LANG = 'PREFS_KEY_LANG';
const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED =
    'PREFS_KEY_ONBOARDING_SCREEN_VIEWED';
const String PREFS_KEY_IS_USER_LOGGED_IN = 'PREFS_KEY_IS_USER_LOGGED_IN';

class AppPrefrences {
  final SharedPreferences _sharedPreferences;
  AppPrefrences(this._sharedPreferences);
  Future<String> getAppLanguage() async {
    String? lanaguge = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (lanaguge != null && lanaguge.isNotEmpty) {
      return lanaguge;
    } else {
      return LangaugeType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LangaugeType.ARABIC.getValue()) {
// set english
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LangaugeType.ENGLISH.getValue());
    } else {
//set arabic
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LangaugeType.ARABIC.getValue());
    }
  }
  Future<Locale> getlocal() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LangaugeType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else {
return ENGLISH_LOCAL;
    }
  }





  // on boarding
  Future<bool> setisOnboardingScreenViewed() async {
    return _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnboardingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED) ??
        false;
  }

  Future<bool> setUserLoggedIn() async {
    return _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }
}
