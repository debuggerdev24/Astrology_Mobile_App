import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';

Widget myIndicator([Color? color]) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.h,
      children: [
        CircularProgressIndicator(
          strokeCap: StrokeCap.round,

          color: AppColors.whiteColor,
        ),
        Text("Loading...", style: regular()),
      ],
    ),
  );
}

Widget topBar({
  required BuildContext context,
  bool? showBackButton,
  String? title,
  Widget? actionIcon,
  Widget? leadingIcon,
}) {
  return Row(
    mainAxisAlignment: title != null
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.start,
    children: [
      showBackButton ?? true
          ? GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Icon(Icons.arrow_back, color: AppColors.white),
            )
          : SizedBox(width: 20.w),
      buildPageTitle(title: title ?? ""),
      actionIcon ?? SizedBox(width: 14.w),
    ],
  );
}

Widget buildPageTitle({required String title}) {
  return AppText(
    text: title,
    style: bold(fontSize: 28.sp, fontFamily: AppFonts.secondary),
  );
}
