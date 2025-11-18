import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';

class BirthChartScreen extends StatelessWidget {
  const BirthChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          children: [
            40.h.verticalSpace,
            topBar(context: context, title: translator.birthChart),
            12.h.verticalSpace,
            Consumer<PalmProvider>(
              builder: (context, provider, child) {
                final birthChart = provider.birthChartDetails;
                if (!provider.isGetBirthChartLoading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: AppText(
                          text: translator.palmBirthChartAlignment,
                          style: bold(
                            fontSize: 20,
                            fontFamily: AppFonts.secondary,
                          ),
                        ),
                      ),
                      32.h.verticalSpace,
                      //todo ----------> Birth Chart Summary
                      AppText(
                        text: translator.birthChartSummary,
                        style: semiBold(fontSize: 18, color: AppColors.primary),
                      ),
                      8.h.verticalSpace,
                      topicWithDetails(
                        topic: translator.moonInPisces,
                        details: birthChart!.birthChartSummary.moonSign,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.w,
                        children: [
                          AppText(
                            text: translator.dasha,
                            style: medium(
                              fontSize: 16,
                              color: AppColors.tealColor,
                            ),
                          ),
                          AppText(text: ":", style: medium(fontSize: 16)),
                          Expanded(
                            child: Row(
                              children: [
                                AppText(
                                  text:
                                      "${birthChart.birthChartSummary.dasha} ",
                                  style: medium(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //todo ----------> Palm Summary
                      20.h.verticalSpace,
                      AppText(
                        text: translator.palmReadingSummary,
                        style: semiBold(fontSize: 18, color: AppColors.primary),
                      ),
                      6.h.verticalSpace,
                      AppText(
                        text: birthChart.palmSummary.toString(),
                        style: medium(fontSize: 16),
                      ),
                      //todo ----------> Interpretation Summary
                      20.h.verticalSpace,
                      AppText(
                        text: translator.interpretation,
                        style: semiBold(fontSize: 18, color: AppColors.primary),
                      ),
                      6.h.verticalSpace,
                      AppText(
                        text: birthChart.interpretation,
                        style: medium(fontSize: 16),
                      ),
                      12.h.verticalSpace,
                      AppText(
                        text: birthChart.birthChartSummary.summary,
                        //"Your astrological and palm reading both indicate a favourable period for learning and spiritual growth.",
                        style: medium(fontSize: 16),
                      ),
                      AppButton(
                        onTap: () {
                          context.pushNamed(
                            MobileAppRoutes.remediesListScreen.name,
                          );
                        },
                        margin: EdgeInsets.only(top: 50.h, bottom: 30.h),
                        title: translator.viewRemedies,
                      ),
                    ],
                  );
                }
                return birthChartShimmer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget birthChartShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor,
      highlightColor: Colors.grey[400]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.verticalSpace,
            Center(
              child: Container(
                width: 250.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            32.h.verticalSpace,

            //todo Birth Chart Summary Section
            Container(
              width: 180.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            13.h.verticalSpace,
            Container(
              width: double.infinity,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            6.h.verticalSpace,
            Container(
              width: 200.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            20.h.verticalSpace,

            //todo Palm Reading Summary Section
            Container(
              width: 200.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            13.h.verticalSpace,
            Container(
              width: double.infinity,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            6.h.verticalSpace,
            Container(
              width: double.infinity,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            20.h.verticalSpace,

            //todo Interpretation Section
            Container(
              width: 150.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            12.h.verticalSpace,
            // Multiple lines for interpretation
            ...List.generate(
              6,
              (_) => Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 8.h),
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Container(
              width: 180.w,

              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            25.h.verticalSpace,

            //todo Bottom note text
            Container(
              width: double.infinity,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            6.h.verticalSpace,
            Container(
              width: 220.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            50.h.verticalSpace,

            // Button shimmer
            Container(
              width: double.infinity,
              height: 54.h,
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

  Widget topicWithDetails({required String topic, required String details}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          AppText(
            text: topic,
            style: medium(fontSize: 16, color: AppColors.tealColor),
          ),
          AppText(text: ":", style: medium(fontSize: 16)),
          Expanded(
            child: AppText(text: details, style: medium(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
