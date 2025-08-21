import 'package:animate_do/animate_do.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import 'app_button.dart';

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
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                context.pop();
              },
              child: SizedBox(
                height: 28.h,
                width: 28.w,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                  size: 25.w,
                ),
              ),
            )
          : SizedBox(width: 20.w),
      Expanded(
        child: buildPageTitle(title: title ?? "", context: context),
      ),
      actionIcon ?? SizedBox(width: 14.w),
    ],
  );
}

Widget buildPageTitle({required String title, required BuildContext context}) {
  return AppText(
    text: title,
    textAlign: TextAlign.center,
    style: bold(
      fontSize: (context.watch<LocaleProvider>().localeCode == "ta")
          ? 22.sp
          : 26.sp,
      fontFamily: AppFonts.secondary,
    ),
  );
}

Widget greyColoredBox({
  EdgeInsets? margin,
  required EdgeInsets padding,
  required Widget child,
}) {
  return Container(
    margin: margin,
    padding: padding,
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.whiteColor),
      borderRadius: BorderRadius.circular(8.r),
      color: AppColors.greyColor,
    ),
    child: child,
  );
}

Future<dynamic> showPremiumDialog({
  required BuildContext context,
  required String title,
  required Widget contentBody,
}) {
  return showDialog(
    barrierColor: AppColors.black.withValues(alpha: 0.7),
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ZoomIn(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        child: AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
          title: Center(
            child: AppText(
              text: title, //"Premium Access"
              style: bold(
                fontSize: 28.sp,
                color: AppColors.darkBlue,
                fontFamily: AppFonts.secondary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              contentBody,
              30.h.verticalSpace,
              Row(
                spacing: 12.w,
                children: [
                  Expanded(child: AppButton(title: "Upgrade Now")),
                  Expanded(
                    child: AppButton(
                      onTap: () {
                        context.pop();
                      },
                      title: "Cancel",
                      buttonColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [],
        ),
      );
      // .animate().scaleXY(
      //   begin: 0.4,
      //   end: 1,
      //   duration: 200.ms,
      //   curve: Curves.fastOutSlowIn,
      // );

      // .then(delay: 200.ms)
      // .scaleXY(begin: 1.5, end: 0.5, duration: 500.ms);
    },
  );
}
