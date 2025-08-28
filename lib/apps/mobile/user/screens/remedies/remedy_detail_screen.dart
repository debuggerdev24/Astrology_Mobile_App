import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/mobile_routes/user_routes.dart';

class RemedyDetailScreen extends StatelessWidget {
  const RemedyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.h.verticalSpace,
            topBar(context: context, title: "Sun Remedy"),
            12.h.verticalSpace,
            AppText(
              textAlign: TextAlign.center,
              style: bold(fontSize: 18, fontFamily: AppFonts.secondary),
              text:
                  "This remedy enhances confidence, boosts focus, and reduces ego imbalance.",
            ),
            remedyPlayer(context, translator),
            AppText(
              text: translator.suggestedAction,
              style: semiBold(fontSize: 18, color: AppColors.primary),
            ),

            18.h.verticalSpace,
            AppText(
              text: "1. Offer water to the sun at sunrise daily.",
              style: medium(fontSize: 16),
            ),
            7.h.verticalSpace,
            AppText(
              text: "2. Donate jaggery and wheat on Sundays.",
              style: medium(fontSize: 16),
            ),
            7.h.verticalSpace,
            AppText(
              text: "3. Chant “Om Suryaya Namah” 108 times.",
              style: medium(fontSize: 16),
            ),
            32.h.verticalSpace,
            AppText(
              text: translator.textInstruction,
              style: semiBold(fontSize: 18, color: AppColors.primary),
            ),

            18.h.verticalSpace,
            AppText(
              text: "Stand facing the rising sun",
              style: medium(fontSize: 16),
            ),
            7.h.verticalSpace,
            AppText(
              text: "Offer water from a copper vessel",
              style: medium(fontSize: 16),
            ),
            7.h.verticalSpace,
            AppText(
              text: "Chant “Om Suryaya Namah” with focus",
              style: medium(fontSize: 16),
            ),
            32.h.verticalSpace,
            AppText(
              text: translator.spiritualMeaning,
              style: semiBold(fontSize: 18, color: AppColors.primary),
            ),

            18.h.verticalSpace,
            AppText(
              text: "This ritual aligns your energy with the solar frequency.",
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
      ),
    );
  }

  Widget remedyPlayer(BuildContext context, AppLocalizations translator) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 22.h),
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
                text: "Om Surya Naamh",
                style: regular(fontSize: 18, color: AppColors.black),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AppText(
                  text: "${translator.meaning} : I bow to Lord Shiva",
                  style: regular(fontSize: 14.sp, color: Colors.grey),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    MobileAppRoutes.remedyPlayerScreen.name,
                    extra: true,
                  );
                },
                child: SVGImage(path: AppAssets.tIcon, height: 34.w),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    MobileAppRoutes.remedyPlayerScreen.name,
                    extra: false,
                  );
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
