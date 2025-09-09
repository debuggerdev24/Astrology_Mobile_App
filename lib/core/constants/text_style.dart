import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppFonts {
  AppFonts._();

  static const primary = "Primary";
  static const secondary = "Secondary";
}

TextStyle light({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) => TextStyle(
  fontSize: fontSize.spMin,
  color: color ?? AppColors.whiteColor,
  height: height,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w300,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
);

TextStyle regular({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  FontWeight? fontWeight,
}) => TextStyle(
  fontSize: fontSize.spMin,
  color: color ?? AppColors.whiteColor,
  height: height,
  fontFamily: fontFamily,
  fontWeight: fontWeight ?? FontWeight.normal,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
);

TextStyle medium({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) => TextStyle(
  fontSize: fontSize.spMin,
  color: color ?? AppColors.whiteColor,
  height: height,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
);

TextStyle semiBold({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) => TextStyle(
  fontSize: fontSize.spMin,
  color: color ?? AppColors.whiteColor,
  height: height,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
);

TextStyle bold({
  double? fontSize,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  FontWeight? fontWeight,
}) => TextStyle(
  fontSize: fontSize?.spMin,
  color: color ?? AppColors.whiteColor,
  height: height,
  fontFamily: fontFamily,
  fontWeight: fontWeight ?? FontWeight.w700,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
);
