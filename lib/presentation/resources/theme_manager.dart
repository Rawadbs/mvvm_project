import 'package:advance_flutter/presentation/resources/color_manager.dart';
import 'package:advance_flutter/presentation/resources/fonts_manager.dart';
import 'package:advance_flutter/presentation/resources/styles_manager.dart';
import 'package:advance_flutter/presentation/resources/values_manger.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
// main colors
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,

// cardview theme
    cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),
// app bar theme
    appBarTheme: AppBarTheme(
      color: ColorManager.primary,
      centerTitle: true,
      elevation: AppSize.s0,
      scrolledUnderElevation: AppSize.s0,
      titleTextStyle: getRegularStyle(
        fontSize: FontSize.s16,
        color: ColorManager.white,
      ),
    ),
    
//button theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: ColorManager.grey1,
        buttonColor: ColorManager.primary,
        splashColor: ColorManager.lightPrimary),

//elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary,
        textStyle:
            getRegularStyle(color: ColorManager.white, fontSize: FontSize.s17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),
//text theme
    textTheme: TextTheme(
        displayLarge: getSemiBoldStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s16),
        headlineLarge: getRegularStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s16),
        headlineMedium: getRegularStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s14),
        titleMedium: getSemiBoldStyle(
            color: ColorManager.primary, fontSize: FontSize.s18),  //--blue
        headlineSmall: getSemiBoldStyle(
            color: ColorManager.primary, fontSize: FontSize.s16),  //--blue
        labelSmall:
            getBoldStyle(color: ColorManager.white, fontSize: FontSize.s16),
        titleLarge:
            getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s12),
        bodyLarge: getRegularStyle(color: ColorManager.grey1),
        bodySmall: getRegularStyle(color: ColorManager.grey),
        labelMedium:
            getRegularStyle(color: ColorManager.grey2, fontSize: FontSize.s12),
        displayMedium:
            getBoldStyle(color: ColorManager.black1, fontSize: FontSize.s24),
        titleSmall:
            getBoldStyle(color: ColorManager.white, fontSize: FontSize.s60),
        bodyMedium: getRegularStyle(
            color: ColorManager.lightGrey, fontSize: FontSize.s14),
        displaySmall:
            getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s22)),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
      fillColor: ColorManager.lightGrey1,
      //content padding
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      //hint style
      hintStyle:
          getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
      //label style
      labelStyle:
          getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),
      //error style
      errorStyle: getRegularStyle(
        color: ColorManager.error,
      ),
      //enabled border style
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.lightGrey1, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      //focused border style
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      //error border style
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      //focus error border
      focusedErrorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
    ),
  ); //input decoration theme (text form field)
}
