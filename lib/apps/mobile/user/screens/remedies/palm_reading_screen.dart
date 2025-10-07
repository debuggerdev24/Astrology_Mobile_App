import 'package:animate_do/animate_do.dart';
import 'package:astrology_app/apps/mobile/user/model/remedies/palm_reading_model.dart';
import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        warningDialog(context, translator);
      },
      child: AppLayout(
        body: SingleChildScrollView(
          child: Column(
            children: [
              40.h.verticalSpace,
              topBar(
                context: context,
                title: translator.palmReading,
                onLeadingTap: () {
                  warningDialog(context, translator);
                },
              ),

              Consumer<PalmProvider>(
                builder: (context, provider, child) {
                  if (!provider.isUploading) {
                    final palm = (provider.selectedIndex == 0)
                        ? provider.palmReading!.leftPalm
                        : provider.palmReading!.rightPalm;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        15.h.verticalSpace,
                        toggleLeftRight(
                          translator: translator,
                          provider: provider,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 30.h, bottom: 24.h),
                            width: 285.w,
                            height: 200.h,
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
                            child: CachedNetworkImage(
                              imageUrl: palm.image,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(5).r,
                                ),
                                padding: EdgeInsets.all(12).r,
                                child: CupertinoActivityIndicator(
                                  radius: 18.h,
                                  color: AppColors.bgColor,
                                ),
                              ),
                            ),
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
                          details: palm.summary.lifeline,
                        ),
                        topicWithDetails(
                          topic: translator.headLine,
                          details: palm.summary.headline,
                        ),
                        topicWithDetails(
                          topic: translator.heartLine,
                          details: palm.summary.heartline,
                        ),
                        // 12.h.verticalSpace,
                        Consumer<SubscriptionProvider>(
                          builder: (context, subscriptionProvider, child) {
                            if (!subscriptionProvider.isTier2Subscribed) {
                              return mountAnalysisLocked(
                                translator: translator,
                              );
                            }
                            return mountAnalysis(
                              translator: translator,
                              palm: palm,
                            );
                          },
                        ),

                        AppButton(
                          onTap: () {
                            if (context
                                .read<SubscriptionProvider>()
                                .isTier2Subscribed) {
                              context.pushNamed(
                                MobileAppRoutes.remediesListScreen.name,
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
                                          .premiumMessageMatchWithRemedies,
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
                                          .premiumSloganMessageRemedies,
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
                              if (provider.birthChartDetails == null) {
                                provider.getBirthChartDetails();
                              }
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
                          onTap: () {
                            warningDialog(context, translator);
                          },
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
                    );
                  }
                  return palmReadingShimmer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget palmReadingShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor,
      highlightColor: Colors.grey[400]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.verticalSpace,

            // Tab bar shimmer (2 tabs)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                8.w.horizontalSpace,
                Expanded(
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            16.h.verticalSpace,

            // Palm image placeholder
            Center(
              child: Container(
                width: 180.w,
                height: 180.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.greyColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              ),
            ),

            20.h.verticalSpace,

            // Main heading
            Container(
              width: 120.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            12.h.verticalSpace,

            // Details sections (5-6 items)
            ...List.generate(
              2,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label
                    Container(
                      width: 150.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    6.h.verticalSpace,
                    // Value (2 lines)
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    4.h.verticalSpace,
                    Container(
                      width: 220.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            20.h.verticalSpace,

            // Bottom description text (3-4 lines)
            ...List.generate(
              4,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Container(
                  width: double.infinity,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Container(
              width: 180.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            30.h.verticalSpace,

            // Section title
            Container(
              width: 200.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            16.h.verticalSpace,

            // Button 1
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            12.h.verticalSpace,

            // Button 2
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            30.h.verticalSpace,
          ],
        ),
      ),
    );
  }

  Future<dynamic> warningDialog(
    BuildContext context,
    AppLocalizations translator,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return ZoomIn(
          child: AlertDialog(
            title: AppText(
              textAlign: TextAlign.center,
              text: "${translator.warning} !",
              style: semiBold(color: AppColors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  textAlign: TextAlign.center,
                  text: translator.warnMessage,
                  style: regular(color: AppColors.black, height: 1.1),
                ),
                30.verticalSpace,
                Row(
                  spacing: 12.w,
                  children: [
                    Expanded(
                      child: AppButton(
                        fontSize: 15,
                        title: translator.add,
                        onTap: () {
                          context.pop();
                          context.pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        onTap: () {
                          context.pop();
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
        );
      },
    );
  }

  Widget toggleLeftRight({
    required AppLocalizations translator,
    required PalmProvider provider,
  }) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,

        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          toggleButton(
            text: translator.leftHand,
            isSelected: provider.selectedIndex == 0,
            onTap: () {
              provider.toggleHand(index: 0);
            },
          ),
          toggleButton(
            text: translator.rightHand,
            isSelected: provider.selectedIndex == 1,
            onTap: () {
              provider.toggleHand(index: 1);
            },
          ),
        ],
      ),
    );
  }

  Widget toggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }

  Widget mountAnalysis({
    required AppLocalizations translator,
    required TPalm palm,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: translator.mountAnalysis,
          style: semiBold(
            fontSize: context.isTamil ? 16 : 18,
            color: AppColors.primary,
          ),
        ),
        12.h.verticalSpace,
        if (palm.mountAnalysis.mountOfVenus!.isNotEmpty)
          topicWithDetails2(
            topic: translator.mountOfVenus,
            details: palm.mountAnalysis.mountOfVenus!,
          ),
        if (palm.mountAnalysis.mountOfJupiter!.isNotEmpty)
          topicWithDetails2(
            topic: translator.mountOfJupiter,
            details: palm.mountAnalysis.mountOfJupiter!,
          ),
        if (palm.mountAnalysis.mountOfSaturn!.isNotEmpty)
          topicWithDetails2(
            topic: translator.mountOfSaturn,
            details: palm.mountAnalysis.mountOfSaturn!,
          ),
        if (palm.mountAnalysis.mountOfSun!.isNotEmpty)
          topicWithDetails2(
            topic: translator.mountOfSun,
            details: palm.mountAnalysis.mountOfSun!,
          ),
        AppText(
          text: palm.mountAnalysis.monthlySummary!,
          style: medium(fontSize: context.isTamil ? 14 : 16),
        ),
      ],
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
            topic: translator.mountOfJupiter,
            details: "Dominant (leadership)",
            isLocked: true,
          ),
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
