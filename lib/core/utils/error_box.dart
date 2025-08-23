import 'package:animate_do/animate_do.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/app_text.dart';

class ErrorBox extends StatelessWidget {
  final String errorMessage;
  final double? paddingLeft;

  const ErrorBox({super.key, required this.errorMessage, this.paddingLeft});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      from: 32.0,
      animate: true,
      curve: Curves.fastOutSlowIn,
      key: ValueKey(errorMessage),
      duration: Duration(milliseconds: 400),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.bounceOut,
        margin: EdgeInsets.only(top: 5.sp),
        padding: EdgeInsets.only(
          top: 14.h,
          bottom: 14.h,
          left: paddingLeft ?? 13,

          right: 8.w,
        ),

        decoration: BoxDecoration(
          color: Color(0xd7ffe4e4),
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(color: AppColors.redColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SVGImage(
              path: AppAssets.errorIcon,
              color: AppColors.errorTextColor,
            ),
            10.w.horizontalSpace,
            Expanded(
              child: AppText(
                text: errorMessage,
                style: medium(color: Colors.red.shade900, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
