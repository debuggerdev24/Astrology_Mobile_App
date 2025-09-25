import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../apps/mobile/user/provider/setting/locale_provider.dart';
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
  VoidCallback? onLeadingTap,
  bool? showBackButton,
  String? title,
  Widget? actionIcon,
  Widget? leadingIcon,
}) {
  return Row(
    // crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: title != null
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.start,
    children: [
      showBackButton ?? true
          ? GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap:
                  onLeadingTap ??
                  () {
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
          ? 22
          : (Platform.isAndroid)
          ? 28
          : 26,
      fontFamily: AppFonts.secondary,
    ),
  );
}

Widget greyColoredBox({
  EdgeInsets? margin,
  double? height,
  Color? borderColor,
  required EdgeInsets padding,
  width,
  required Widget child,
}) {
  return Container(
    height: height,
    width: width,
    margin: margin,
    padding: padding,
    decoration: BoxDecoration(
      border: Border.all(color: borderColor ?? AppColors.whiteColor),
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
                fontSize: 28,
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
                  Expanded(
                    child: AppButton(
                      fontSize: 15,
                      title: "Upgrade Now",
                      onTap: () {
                        context.pop();
                        context.pushNamed(
                          MobileAppRoutes.premiumPlanScreen.name,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: AppButton(
                      onTap: () {
                        context.pop();
                      },
                      fontSize: 15,
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
