import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/app_tutorial/daily_mantra_screen_tour.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import 'app_tour.dart';

class PalmReadingScreenTour extends StatefulWidget {
  const PalmReadingScreenTour({super.key});

  @override
  State<PalmReadingScreenTour> createState() => _PalmReadingScreenTourState();
}

class _PalmReadingScreenTourState extends State<PalmReadingScreenTour> {
  int index = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });

    super.initState();
  }

  void _showTutorial() {
    // Check your existing shared prefs here
    // if (!yourSharedPrefs.hasSeenPalmUploadTutorial) {
    AppTourManager.showPalmReadingTutorial(
      context: context,
      onFinish: () {
        // Save to your shared prefs
        // yourSharedPrefs.setPalmUploadTutorialSeen();

        context.pushNamed(MobileAppRoutes.remediesListScreenTour.name);
      },
      onSkip: () {
        onSkip(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return PopScope(
      canPop: false,
      child: AppLayout(
        horizontalPadding: 0,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              //todo main body
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    40.h.verticalSpace,
                    topBar(context: context, title: translator.palmReading),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        15.h.verticalSpace,
                        toggleLeftRight(translator: translator),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 30.h,
                                  bottom: 24.h,
                                ),
                                width: 260.w,
                                height: 180.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.whiteColor,
                                    width: 2,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50.w,
                                  vertical: 18.h,
                                ),
                                child: Image.asset(AppAssets.palm),
                              ),
                            ),
                            AppText(
                              text: translator.summary,
                              style: semiBold(
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
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
                            mountAnalysisLocked(translator: translator),
                          ],
                        ),
                        AppButton(
                          onTap: () {
                            context.pushNamed(
                              MobileAppRoutes.remediesListScreenTour.name,
                            );
                          },
                          buttonColor: AppColors.secondary,
                          margin: EdgeInsets.only(top: 48.h, bottom: 14.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 10.w,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                textAlign: TextAlign.center,
                                text: translator.viewRemedies,
                                style: bold(
                                  fontSize: context.isTamil ? 14 : 16,
                                  color: AppColors.black,
                                ),
                              ),
                              if (!context
                                  .read<SubscriptionProvider>()
                                  .isTier2Subscribed)
                                SVGImage(
                                  path: AppAssets.lockIcon,
                                  color: AppColors.darkBlue,
                                ),
                            ],
                          ),
                        ),
                        AppButton(
                          margin: EdgeInsets.only(bottom: 18.h),
                          onTap: () {
                            if (context
                                .read<SubscriptionProvider>()
                                .isTier2Subscribed) {
                              context.pushNamed(
                                MobileAppRoutes.birthChartScreen.name,
                              );
                            } else {
                              showPremiumDialog(
                                context: context,
                                title: translator.premiumAccess,
                                contentBody: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    18.h.verticalSpace,
                                    AppText(
                                      textAlign: TextAlign.center,
                                      text: translator
                                          .premiumMessageMatchWithBirthChart,
                                      //'The "Match with Birth Chart" feature is available exclusively for Premium Plan (Tier 2) users.',
                                      style: medium(
                                        fontSize: 16,
                                        color: AppColors.black.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                    8.h.verticalSpace,
                                    AppText(
                                      textAlign: TextAlign.center,
                                      text: translator
                                          .premiumSloganMessageMatchWithBirthChart,
                                      // "Unlock advanced insights by aligning your palm reading with your birth chart for a more accurate spiritual analysis.",
                                      style: medium(
                                        fontSize: 16,
                                        color: AppColors.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10.w,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  textAlign: TextAlign.center,
                                  text: translator.matchWithBirthCart,
                                  style: bold(
                                    fontSize: context.isTamil ? 14 : 16,
                                    color: AppColors.black,
                                  ),
                                ),
                                if (!context
                                    .read<SubscriptionProvider>()
                                    .isTier2Subscribed)
                                  SVGImage(
                                    path: AppAssets.lockIcon,
                                    color: AppColors.darkBlue,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        AppButton(
                          margin: EdgeInsets.only(bottom: 18.h),
                          onTap: () {},
                          child: AppText(
                            textAlign: TextAlign.center,
                            text: translator.addNewPalm,
                            style: bold(
                              fontSize: context.isTamil ? 14 : 16,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        30.h.verticalSpace,
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.sw,
                height: 1.sh,
                color: AppColors.black.withValues(alpha: 0.5),
              ),
              //todo static dialogue
              Container(
                alignment: AlignmentGeometry.center,
                width: 1.sw,
                height: 1.sh,
                child: Container(
                  key: AppTourKeys.premiumDialogKey,
                  height: 310.h,
                  width: 320.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        textAlign: TextAlign.center,
                        text:
                            context.translator.premiumAccess, //"Premium Access"
                        style: bold(
                          fontSize: 28,
                          color: AppColors.darkBlue,
                          fontFamily: AppFonts.secondary,
                        ),
                      ),
                      18.h.verticalSpace,
                      AppText(
                        textAlign: TextAlign.center,
                        text:
                            context.translator.premiumMessageMatchWithRemedies,
                        style: medium(
                          fontSize: 16,
                          color: AppColors.black.withValues(alpha: 0.8),
                        ),
                      ),
                      8.h.verticalSpace,
                      AppText(
                        textAlign: TextAlign.center,
                        text: context.translator.premiumSloganMessageRemedies,
                        style: medium(fontSize: 16, color: AppColors.greyColor),
                      ),
                      30.h.verticalSpace,
                      Row(
                        spacing: 12.w,
                        children: [
                          Expanded(
                            child: AppButton(
                              fontSize: 15,
                              title: AppLocalizations.of(context)!.upgradeNow,
                              onTap: () {
                                // context.pop();
                                // context.pushNamed(
                                //   MobileAppRoutes.premiumPlanScreen.name,
                                // );
                                context.pushNamed(
                                  MobileAppRoutes.remediesListScreenTour.name,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: AppButton(
                              onTap: () {
                                context.pushNamed(
                                  MobileAppRoutes.remediesListScreenTour.name,
                                );
                              },
                              fontSize: 15,
                              title: AppLocalizations.of(context)!.cancel,
                              buttonColor: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toggleLeftRight({required AppLocalizations translator}) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,

        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          toggleButton(text: translator.leftHand, isSelected: true),
          toggleButton(text: translator.rightHand, isSelected: false),
        ],
      ),
    );
  }

  Widget toggleButton({required String text, required bool isSelected}) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greyColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: AppText(
          text: text,
          style: medium(
            fontSize: 14,
            color: isSelected ? null : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget mountAnalysisLocked({required AppLocalizations translator}) {
    return GestureDetector(
      onTap: () {
        showPremiumDialog(
          context: context,
          title: translator.premiumAccess,
          contentBody: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              18.h.verticalSpace,
              AppText(
                textAlign: TextAlign.center,
                text: translator.premiumMessageMountAnalysis,
                //"To view detailed Mount Analysis, please upgrade to a Premium Plan (Tier 2).",
                style: medium(
                  fontSize: 16,
                  color: AppColors.black.withValues(alpha: 0.8),
                ),
              ),
              8.h.verticalSpace,
              AppText(
                textAlign: TextAlign.center,
                text: translator
                    .premiumSloganMessageMountAnalysis, //"Unlock personalized insights into your palm’s mounts and their influence on your life path.",
                style: medium(fontSize: 16, color: AppColors.greyColor),
              ),
            ],
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10.w,
            children: [
              AppText(
                text: translator.mountAnalysis,
                style: semiBold(fontSize: 18, color: AppColors.primary),
              ),
              SVGImage(path: AppAssets.lockIcon, height: 18.h),
            ],
          ),
          12.h.verticalSpace,
          topicWithDetails2(
            topic: translator.mountOfVenus,
            details: "Balanced (love & com-passion)",
            isLocked: true,
          ),
          AppText(
            text:
                "Your palm indicates a balance of logic and intuition. Likely to lead with emotional wisdom. Favorable times for career: Aug–Nov.",
            style: medium(
              fontSize: 16,
              color: AppColors.whiteColor.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget topicWithDetails({
    required String topic,
    required String details,
    int,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          AppText(
            text: topic,
            style: medium(fontSize: 14, color: Color(0xff4EF4E4)),
          ),
          AppText(text: ":", style: medium(fontSize: 16)),
          Expanded(
            child: AppText(
              text: details,
              style: medium(fontSize: 14, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget topicWithDetails2({
    required String topic,
    required String details,
    bool? isLocked,
  }) {
    isLocked = isLocked ?? false;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          AppText(
            text: topic,
            style: medium(
              fontSize: 14,
              color: Color(0xff4EF4E4).withValues(alpha: (isLocked) ? 0.2 : 1),
            ),
          ),
          AppText(
            text: ":",
            style: medium(
              fontSize: 16,
              color: AppColors.whiteColor.withValues(
                alpha: (isLocked) ? 0.2 : 1,
              ),
            ),
          ),
          Expanded(
            flex: 3.5.toInt(),
            child: AppText(
              text: details,
              style: medium(
                height: 1.3,
                fontSize: 14,
                color: AppColors.whiteColor.withValues(
                  alpha: (isLocked) ? 0.2 : 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
