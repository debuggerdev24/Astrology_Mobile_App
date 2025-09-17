import 'package:astrology_app/apps/mobile/user/model/remedies/palm_reading_model.dart';
import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
        child: Consumer<PalmProvider>(
          builder: (context, provider, child) {
            if (provider.palmReading == null) {
              return ApiLoadingIndicator();
            }
            final palm = (provider.selectedIndex == 0)
                ? provider.palmReading!.leftPalm
                : provider.palmReading!.rightPalm;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.h.verticalSpace,
                topBar(context: context, title: translator.palmReading),
                15.h.verticalSpace,
                toggleLeftRight(translator: translator, provider: provider),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 30.h, bottom: 24.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.whiteColor, width: 2),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 82.w,
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
                  style: semiBold(fontSize: 18, color: AppColors.primary),
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
                      return mountAnalysisLocked(translator: translator);
                    }
                    return mountAnalysis(translator: translator, palm: palm);
                  },
                ),

                // AppButton(
                //   onTap: () {
                //     context.pushNamed(MobileAppRoutes.remediesListScreen.name);
                //     provider.getRemedies();
                //   },
                //   title: translator.viewRemedies,
                //   buttonColor: AppColors.secondary,
                //   margin: EdgeInsets.only(top: 48.h, bottom: 14.h),
                // ),
                AppButton(
                  margin: EdgeInsets.only(top: 48.h, bottom: 18.h),
                  onTap: () {
                    if (context
                        .read<SubscriptionProvider>()
                        .isTier2Subscribed) {
                      context.pushNamed(MobileAppRoutes.birthChartScreen.name);
                      if (provider.birthChartDetails == null) {
                        provider.getBirthChartDetails();
                      }
                    } else {
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
                              style: medium(
                                fontSize: 16,
                                color: AppColors.black.withValues(alpha: 0.8),
                              ),
                            ),
                            8.h.verticalSpace,
                            AppText(
                              textAlign: TextAlign.center,
                              text:
                                  "Unlock personalized insights into your palm’s mounts and their influence on your life path.",
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
                          style: bold(fontSize: 16, color: AppColors.black),
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

                30.h.verticalSpace,
              ],
            );
          },
        ),
      ),
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
          style: semiBold(fontSize: 18, color: AppColors.primary),
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
            topic: "Mount Of Saturn",
            details: palm.mountAnalysis.mountOfSaturn!,
          ),
        if (palm.mountAnalysis.mountOfSun!.isNotEmpty)
          topicWithDetails2(
            topic: "Mount Of Sun",
            details: palm.mountAnalysis.mountOfSun!,
          ),
        AppText(
          text: palm.mountAnalysis.monthlySummary!,
          style: medium(fontSize: 16),
        ),
      ],
    );
  }

  Widget mountAnalysisLocked({required AppLocalizations translator}) {
    return Column(
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
    );
  }

  Widget topicWithDetails({
    required String topic,
    required String details,
    int,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          Expanded(
            child: AppText(
              text: topic,
              style: medium(fontSize: 16, color: Color(0xff4EF4E4)),
            ),
          ),
          AppText(text: ":", style: medium(fontSize: 16)),
          Expanded(
            flex: 3.5.toInt(),
            child: AppText(text: details, style: medium(fontSize: 16)),
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          AppText(
            text: topic,
            style: medium(
              fontSize: 16,
              color: Color(0xff4EF4E4).withValues(alpha: (isLocked) ? 0.2 : 1),
            ),
          ),
          AppText(
            text: ":",
            style: medium(
              fontSize: 16,
              color: Color(0xff4EF4E4).withValues(alpha: (isLocked) ? 0.2 : 1),
            ),
          ),
          Expanded(
            flex: 3.5.toInt(),
            child: AppText(
              text: details,
              style: medium(
                fontSize: 16,
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
