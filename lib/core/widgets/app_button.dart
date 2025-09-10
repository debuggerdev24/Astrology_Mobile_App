import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String? title;
  final EdgeInsets? margin;
  final double? width, fontSize, verticalPadding, horizontalPadding;
  final Color? buttonColor, titleColor;
  final VoidCallback? onTap, onLongPress;
  final Widget? child;
  const AppButton({
    super.key,
    this.title,
    this.margin,
    this.onTap,
    this.width,
    this.buttonColor,
    this.child,
    this.fontSize,
    this.verticalPadding,
    this.onLongPress,
    this.horizontalPadding,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        alignment: Alignment.center,
        margin: margin,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding == null ? 14.h : verticalPadding!.h,
          horizontal: horizontalPadding == null ? 0 : verticalPadding!.w,
        ),
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: (title == null)
            ? child
            : AppText(
                overflow: TextOverflow.ellipsis,
                text: title ?? "",
                style: bold(
                  fontSize: fontSize ?? 16.sp,
                  color: titleColor ?? AppColors.black,
                ),
              ),
      ),
    );
  }
}
