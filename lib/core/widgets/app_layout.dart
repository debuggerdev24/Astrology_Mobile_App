import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/app_colors.dart';

class AppLayout extends StatefulWidget {
  final Widget body;
  final double? horizontalPadding, topPadding;
  const AppLayout({
    super.key,
    required this.body,
    this.horizontalPadding,
    this.topPadding,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // or your desired color
        statusBarIconBrightness:
            Brightness.light, // Dark icons for light background
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    // Optional: Reset to default when leaving screen
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // or your desired color
        statusBarIconBrightness:
            Brightness.light, // Dark icons for light background
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 30.h,
          left: widget.horizontalPadding ?? 12.w,
          right: widget.horizontalPadding ?? 12.w,
        ),
        child: widget.body,
      ),
    );
  }
}

void showToast([String? msg, int? seconds]) {
  Fluttertoast.showToast(
    fontAsset: "Primary",
    msg: msg!,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: seconds ?? 2,
    backgroundColor: AppColors.black,
    textColor: Colors.white,
    fontSize: 14,
  );
}
