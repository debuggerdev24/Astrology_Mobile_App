import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
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
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
                  12.h.verticalSpace,
                  AppText(
                    textAlign: TextAlign.center,
                    style: bold(fontSize: 18, fontFamily: AppFonts.secondary),
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
                    style: semiBold(fontSize: 18, color: AppColors.primary),
                  ),

                  18.h.verticalSpace,
                  ...List.generate(remedy.suggestedAction.length, (index) {
                    final action = remedy.suggestedAction[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 7.h),
                      child: AppText(
                        text: "${index + 1}. $action",
                        style: medium(fontSize: 16),
                      ),
                    );
                  }),
                  25.h.verticalSpace,
                  AppText(
                    text: translator.textInstruction,
                    style: semiBold(fontSize: 18, color: AppColors.primary),
                  ),

                  18.h.verticalSpace,
                  ...List.generate(remedy.textInstructions.length, (index) {
                    final instruction = remedy.textInstructions[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 7.h),
                      child: AppText(
                        text: instruction,
                        style: medium(fontSize: 16),
                      ),
                    );
                  }),

                  25.h.verticalSpace,
                  AppText(
                    text: translator.spiritualMeaning,
                    style: semiBold(fontSize: 18, color: AppColors.primary),
                  ),

                  18.h.verticalSpace,
                  AppText(
                    text: remedy.spiritualMeaning,
                    //"This ritual aligns your energy with the solar frequency.",
                    style: medium(fontSize: 16),
                  ),
                  AppButton(
                    onTap: () {
                      context.pushNamed(MobileAppRoutes.setReminderScreen.name);
                    },
                    title: translator.setReminder,
                    margin: EdgeInsets.only(top: 52.h, bottom: 20.h),
                  ),
                ],
              ),
            );
          }
          return ApiLoadingIndicator();
        },
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
                    MobileAppRoutes.remedyPlayerScreen.name,
                    extra: {
                      "isText": true,
                      "mantraName": mantra.name,
                      "meaning": mantra.meaning,
                      "textContent": mantra.text,
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
                        "mantraName": mantra.name,
                        "meaning": mantra.meaning,
                        "textContent": mantra.text,
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
