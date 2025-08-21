import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';

class PalmReadingScreen extends StatefulWidget {
  const PalmReadingScreen({super.key});

  @override
  State<PalmReadingScreen> createState() => _PalmReadingScreenState();
}

class _PalmReadingScreenState extends State<PalmReadingScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.h.verticalSpace,
            topBar(context: context, title: translator.palmReading),
            15.h.verticalSpace,
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: index == 0
                              ? AppColors.greyColor
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: AppText(
                          text: translator.leftHand,
                          style: medium(
                            fontSize: 14.sp,
                            color: index == 1 ? AppColors.black : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: index == 1
                              ? AppColors.greyColor
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: AppText(
                          text: translator.rightHand,
                          style: medium(
                            fontSize: 14.sp,
                            color: index == 0 ? AppColors.black : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 30.h, bottom: 24.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.whiteColor, width: 2),
                ),
                padding: EdgeInsets.symmetric(horizontal: 82.w, vertical: 18.h),
                child: Image.asset(AppAssets.palm1),
              ),
            ),
            AppText(
              text: translator.summary,
              style: semiBold(fontSize: 18.sp, color: AppColors.primary),
            ),
            14.h.verticalSpace,
            topicWithDetails(
              topic: translator.lifeLine,
              details: "Strong, steady, good health",
            ),
            topicWithDetails(
              topic: translator.headLine,
              details: "Balanced intellect",
            ),
            topicWithDetails(
              topic: translator.heartLine,
              details: "Emotionally intuitive",
            ),
            12.h.verticalSpace,
            mountAnalysis(translator),
            AppButton(
              onTap: () {
                context.pushNamed(MobileAppRoutes.remediesListScreen.name);
              },
              title: translator.viewRemedies,
              buttonColor: AppColors.secondary,
              margin: EdgeInsets.only(top: 48.h, bottom: 14.h),
            ),
            GestureDetector(
              onLongPress: () {
                showPremiumDialog(
                  context: context,
                  title: "Premium Access",
                  contentBody: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      18.h.verticalSpace,
                      AppText(
                        textAlign: TextAlign.center,
                        text:
                            "To view detailed Mount Analysis, please upgrade to a Premium Plan (Tier 2).",
                        style: medium(fontSize: 16, color: AppColors.black),
                      ),
                      8.h.verticalSpace,
                      AppText(
                        textAlign: TextAlign.center,
                        text:
                            "Unlock personalized insights into your palm’s mounts and their influence on your life path.",
                        style: medium(fontSize: 16, color: AppColors.greyColor),
                      ),
                    ],
                  ),
                );
              },
              onTap: () {
                context.pushNamed(MobileAppRoutes.birthChartScreen.name);
              },

              child: AppButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppText(
                          textAlign: TextAlign.center,
                          text: translator.matchWithBirthCart,
                          style: bold(fontSize: 16, color: AppColors.black),
                        ),
                      ),
                      SVGImage(
                        path: AppAssets.lockIcon,
                        color: AppColors.darkBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            30.h.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget mountAnalysis(AppLocalizations translator) {
    return Column(
      children: [
        Row(
          spacing: 10.w,
          children: [
            AppText(
              text: translator.mountAnalysis,
              style: semiBold(fontSize: 18.sp, color: AppColors.primary),
            ),
            SVGImage(path: AppAssets.lockIcon, height: 18.h),
          ],
        ),
        10.h.verticalSpace,
        topicWithDetails(
          topic: translator.mountOfJupiter,
          details: "Dominant (leadership)",
        ),
        topicWithDetails(
          topic: translator.mountOfVenus,
          details: "Balanced (love & com-passion)",
        ),
        AppText(
          text:
              "Your palm indicates a balance of logic and intuition. Likely to lead with emotional wisdom. Favorable times for career: Aug–Nov.",
          style: regular(),
        ),
      ],
    );
  }

  Widget topicWithDetails({required String topic, required String details}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          AppText(
            text: topic,
            style: medium(fontSize: 16.sp, color: AppColors.secondary),
          ),
          AppText(
            text: ":",
            style: medium(fontSize: 16.sp),
          ),
          Expanded(
            child: AppText(
              text: details,
              style: medium(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
