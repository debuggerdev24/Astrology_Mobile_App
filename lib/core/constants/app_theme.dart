import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData appThemeData = ThemeData(
    scaffoldBackgroundColor: AppColors.bgColor,
    fontFamily: "Primary",
    // appBarTheme: AppBarTheme(
    //   systemOverlayStyle: SystemUiOverlayStyle(
    //     statusBarColor: AppColors.transparent,
    //     statusBarIconBrightness:
    //         Brightness.light, // Light icons for dark background
    //   ),
    // ),
    // appBarTheme: AppBarTheme(
    //
    // ),
    // appBarTheme: AppBarTheme(
    //   elevation: 0,
    //   scrolledUnderElevation: 0,
    //   centerTitle: true,
    //   backgroundColor: AppColors.bgColor,
    //   systemOverlayStyle: SystemUiOverlayStyle.dark,
    // ),
  );
}
