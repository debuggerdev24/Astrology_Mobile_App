import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text.dart';

class CurrentPlanScreen extends StatelessWidget {
  const CurrentPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: translator.currentSubscription),
          28.h.verticalSpace,
          greyColoredBox(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Tier 2 (Advanced)",
                  style: bold(
                    fontSize: 20,
                    fontFamily: AppFonts.secondary,
                    color: AppColors.secondary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.secondary,
                  ),
                ),
                12.h.verticalSpace,
                Row(
                  children: [
                    AppText(text: "• Palmistry", style: regular(fontSize: 18)),
                  ],
                ),
                AppText(
                  text: "• Birth Chart Matching",
                  style: regular(fontSize: 18),
                ),
                AppText(
                  text: "• Detailed Remedies",
                  style: regular(fontSize: 18),
                ),

                20.h.verticalSpace,
                titleWithDetails(title: "Price", details: "\$20.00"),
                titleWithDetails(
                  title: "Subscription date",
                  details: "August 13, 2024",
                ),
                titleWithDetails(
                  title: "Subscription Validity",
                  details: "September 30,2024",
                ),
                20.h.verticalSpace,
                Row(
                  spacing: 10.w,
                  children: [
                    Expanded(
                      child: AppButton(
                        title: context.translator.upgradePlan,
                        verticalPadding: 11.h,
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        color: AppColors.secondary,
                        title: context.translator.cancel,
                        verticalPadding: 11.h,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget titleWithDetails({required String title, required String details}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AppText(text: title, style: regular(fontSize: 18)),
        ),
        AppText(text: ":  ", style: regular(fontSize: 18)),
        Expanded(
          flex: 2,
          child: AppText(text: details, style: regular(fontSize: 18)),
        ),
      ],
    );
  }
}
