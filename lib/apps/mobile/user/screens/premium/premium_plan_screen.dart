import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PremiumPlanScreen extends StatelessWidget {
  const PremiumPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    final List<Map<String, dynamic>> premiumPlans = [
      {
        "title": "${translator.tier} 1 (${translator.premium})",
        "price": 10.00,
        "duration": "1 ${translator.month}",
        "features": [
          translator.dailyMantras,
          translator.historyAccess,
          translator.basicRemedies,
          "1 ${translator.month}",
        ],
      },

      {
        "title": "${translator.tier} 2 (${translator.advanced})",
        "price": 20.00,
        "duration": "1.5 ${translator.month}",
        "features": [
          translator.palmistry,
          translator.birthChartMatching,
          translator.detailedRemedies,

          "1.5 ${translator.months}",
        ],
      },
      {
        "title": "${translator.tier} 3 (${translator.elite})",
        "price": 28.00,
        "duration": "3 ${translator.months}",
        "features": [
          translator.consultBooking,
          translator.allFeaturesUnlocked,
          "3 ${translator.months}",
        ],
      },
    ];

    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: translator.chooseYourPlan),
          6.h.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 20.h,
                children: [
                  SizedBox(),
                  greyColoredBox(
                    padding: EdgeInsets.all(14.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6.h,
                      children: [
                        AppText(
                          text: "${translator.free} :",
                          style: bold(
                            fontSize: 20,
                            fontFamily: AppFonts.secondary,
                            color: AppColors.secondary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.secondary,
                          ),
                        ),
                        SizedBox(),
                        Row(
                          children: [
                            AppText(
                              text: "• ${translator.basicHoroscope}",
                              style: regular(fontSize: 18),
                            ),
                          ],
                        ),
                        AppText(
                          text: "• ${translator.dailyTips}",
                          style: regular(fontSize: 18),
                        ),
                      ],
                    ),
                  ),

                  ...List.generate(premiumPlans.length, (index) {
                    final plan = premiumPlans[index];
                    return premiumPlanBox(
                      translator: translator,
                      plan: plan,
                      onTap: () {
                        context.pushNamed(
                          MobileAppRoutes.selectedPlanScreen.name,
                          extra: plan,
                        );
                      },
                    );
                  }),

                  AppButton(
                    onTap: () {
                      context.pushNamed(MobileAppRoutes.currentPlanScreen.name);
                    },
                    color: AppColors.secondary,
                    title: translator.chooseYourPlan,
                    margin: EdgeInsets.symmetric(vertical: 20.h),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget premiumPlanBox({
  required Map<String, dynamic> plan,
  required AppLocalizations translator,
  VoidCallback? onTap,
  bool? isFromDetailsScreen,
}) {
  return greyColoredBox(
    padding: EdgeInsets.all(14.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: plan["title"],
              style: bold(
                fontSize: 20,
                fontFamily: AppFonts.secondary,
                color: AppColors.secondary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.secondary,
              ),
            ),
            AppText(
              text: "\$${plan["price"].toString()}",
              style: bold(fontSize: 20, color: AppColors.primary),
            ),
          ],
        ),
        12.h.verticalSpace,
        ...(plan["features"] as List).map((f) {
          return Row(
            children: [AppText(text: "• $f", style: regular(fontSize: 18))],
          );
        }),

        if (!(isFromDetailsScreen ?? false)) ...[
          10.h.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  horizontalPadding: 10.w,
                  title: translator.choosePlan,
                  verticalPadding: 11.h,
                  onTap: onTap,
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    ),
  );
}
