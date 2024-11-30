import 'package:advance_flutter/presentation/resources/fonts_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: FontConstant.fontFamily,
      color: color,
      fontWeight: fontWeight);
}

//regular style
TextStyle getRegularStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManger.regular, color);
}

//medium style
TextStyle getMediumStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManger.medium, color);
}

//light style
TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManger.light, color);
}

//bold style
TextStyle getBoldStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManger.bold, color);
}

//semi bold style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManger.semibold, color);
}
