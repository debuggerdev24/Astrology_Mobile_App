import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButtonPrimary extends StatelessWidget {
  final String title;
  final EdgeInsets? margin;
  final double? width;
  final VoidCallback? onTap;
  const AppButtonPrimary({
    super.key,
    required this.title,
    this.margin,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        alignment: Alignment.center,
        margin: margin,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: AppText(
          text: title,
          style: bold(fontSize: 16, color: AppColors.black),
        ),
      ),
    );
  }
}
