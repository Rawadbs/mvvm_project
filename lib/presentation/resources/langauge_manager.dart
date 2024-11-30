import 'package:flutter/material.dart';

enum LangaugeType { ENGLISH, ARABIC }

const String ARABIC = 'ar'; // Arabic language code
const String ENGLISH = 'en'; // English language code
const String ASSET_PATH_LOCALISATIONS =
    'assets/translations'; // English language code
const Locale ARABIC_LOCAL = Locale('ar', 'SA'); // Arabic language code
const Locale ENGLISH_LOCAL = Locale('en', 'US'); // English language code

extension LangaugeTypeExtension on LangaugeType {
  String getValue() {
    switch (this) {
      case LangaugeType.ENGLISH:
        return ENGLISH;
      case LangaugeType.ARABIC:
        return ARABIC;
    }
  }
}
