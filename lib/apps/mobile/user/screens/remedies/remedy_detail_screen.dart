import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../model/remedies/remedy_model.dart';
import '../../provider/mantra/mantra_provider.dart';

class RemedyDetailScreen extends StatelessWidget {
  const RemedyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Consumer<PalmProvider>(
        builder: (context, provider, child) {
          if (!provider.isGetRemediesDetailsLoading) {
            final remedy = provider.remedyDetails;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  40.h.verticalSpace,
                  topBar(
                    context: context,
                    title: remedy!.remedyName.split("-").first,
                  ),
                  21.h.verticalSpace,
                  AppText(
                    textAlign: TextAlign.center,
                    style: regular(fontSize: 15, fontWeight: FontWeight.w500),
                    text: remedy.remedyGain,
                    //"This remedy enhances confidence, boosts focus, and reduces ego imbalance.",
                  ),
                  if (remedy.mantra != null)
                    remedyPlayer(
                      translator: translator,
                      context: context,
                      mantra: remedy.mantra!,
                    ),
                  22.h.verticalSpace,
                  AppText(
                    text: translator.suggestedAction,
                    style: semiBold(fontSize: 16, color: AppColors.primary),
                  ),

                  10.h.verticalSpace,
                  ...List.generate(remedy.suggestedAction.length, (index) {
                    final action = remedy.suggestedAction[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 7.h),
                      child: AppText(
                        text: "${index + 1}. $action",
                        style: medium(fontSize: 14),
                      ),
                    );
                  }),
                  20.h.verticalSpace,
                  AppText(
                    text: translator.textInstruction,
                    style: semiBold(fontSize: 16, color: AppColors.primary),
                  ),

                  10.h.verticalSpace,
                  ...List.generate(remedy.textInstructions.length, (index) {
                    final instruction = remedy.textInstructions[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 7.h),
                      child: AppText(
                        text: instruction,
                        style: medium(fontSize: 14),
                      ),
                    );
                  }),

                  20.h.verticalSpace,
                  AppText(
                    text: translator.spiritualMeaning,
                    style: semiBold(fontSize: 16, color: AppColors.primary),
                  ),

                  10.h.verticalSpace,
                  AppText(
                    text: remedy.spiritualMeaning,
                    //"This ritual aligns your energy with the solar frequency.",
                    style: medium(fontSize: 14),
                  ),
                  AppButton(
                    onTap: () {
                      context.pushNamed(MobileAppRoutes.setReminderScreen.name);
                    },
                    fontSize: context.isTamil ? 14 : 16,

                    title: translator.setReminder,
                    margin: EdgeInsets.only(top: 52.h, bottom: 20.h),
                  ),
                ],
              ),
            );
          }
          return remedyDetailsShimmer();
        },
      ),
    );
  }

  Widget remedyDetailsShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor,
      highlightColor: Colors.grey[400]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.h.verticalSpace,
            //todo Remedy title
            Container(
              width: 200.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            16.h.verticalSpace,

            //todo Description lines (3 lines)
            ...List.generate(
              3,
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

            20.h.verticalSpace,

            //todo Section 1: Recommended Actions
            Container(
              width: 220.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            12.h.verticalSpace,
            //todo List items
            ...List.generate(
              2,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  width: double.infinity,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            20.h.verticalSpace,

            //todo Section 2: How to Apply
            Container(
              width: 180.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            12.h.verticalSpace,
            ...List.generate(
              3,
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
              width: 250.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            20.h.verticalSpace,

            //todo Section 3: Scientific Aspect
            Container(
              width: 160.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            12.h.verticalSpace,
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
              width: 200.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Button shimmer
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 60.h),
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

  Widget remedyPlayer({
    required BuildContext context,
    required AppLocalizations translator,
    required Mantra mantra,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 22.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: AppColors.white,
            blurRadius: 12,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            spacing: 12.w,
            children: [
              SVGImage(path: AppAssets.sunIcon),
              AppText(
                text: mantra.name,
                style: regular(fontSize: 18, color: AppColors.black),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AppText(
                  text: "${translator.meaning} : ${mantra.meaning}",
                  style: regular(fontSize: 14, color: Colors.grey),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<MantraProvider>().resetAudioPlayer();
                  context.pushNamed(
                    MobileAppRoutes.singleMantraPlayerScreen.name,
                    extra: {
                      "isText": true,
                      "isFromDetailScreen": true,
                      "mantraName": mantra.name,
                      "meaning": mantra.meaning,
                      "textContent": mantra.text,
                      "audioFile": mantra.audio,
                    },
                  );
                },

                child: SVGImage(path: AppAssets.tIcon, height: 34.w),
              ),
              GestureDetector(
                onTap: () {
                  Future.wait([
                    context.read<MantraProvider>().loadAndPlayMusic(
                      "http://138.197.92.15${mantra.audio}",
                    ),
                    context.pushNamed(
                      MobileAppRoutes.singleMantraPlayerScreen.name,
                      extra: {
                        "isText": false,
                        "isFromDetailScreen": true,
                        "mantraName": mantra.name,
                        "meaning": mantra.meaning,
                        "textContent": mantra.text,
                        "audioFile": mantra.audio,
                      },
                    ),
                  ]);
                },
                child: SVGImage(path: AppAssets.playIcon, height: 34.w),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
