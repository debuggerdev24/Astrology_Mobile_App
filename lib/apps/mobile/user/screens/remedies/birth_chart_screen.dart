import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';

class BirthChartScreen extends StatelessWidget {
  const BirthChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: SingleChildScrollView(
        child: Consumer<PalmProvider>(
          builder: (context, provider, child) {
            final birthChart = provider.birthChartDetails;
            if (!provider.isGetBirthChartLoading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  40.h.verticalSpace,
                  topBar(context: context, title: translator.birthChart),
                  12.h.verticalSpace,
                  Center(
                    child: AppText(
                      text: "Palm + Birth Chart Alignment",
                      style: bold(fontSize: 20, fontFamily: AppFonts.secondary),
                    ),
                  ),
                  32.h.verticalSpace,
                  AppText(
                    text: translator.birthChartSummary,
                    style: semiBold(fontSize: 18.sp, color: AppColors.primary),
                  ),
                  14.h.verticalSpace,
                  topicWithDetails(
                    topic: translator.moonInPisces,
                    details: birthChart!.birthChartSummary.moonSign,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.w,
                      children: [
                        AppText(
                          text: translator.dasha,
                          style: medium(
                            fontSize: 16.sp,
                            color: AppColors.secondary,
                          ),
                        ),
                        AppText(
                          text: ":",
                          style: medium(fontSize: 16.sp),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              AppText(
                                text: "${birthChart.birthChartSummary.dasha} ",
                                style: medium(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  32.h.verticalSpace,
                  AppText(
                    text: translator.palmReadingSummary,
                    style: semiBold(fontSize: 18.sp, color: AppColors.primary),
                  ),
                  14.h.verticalSpace,
                  AppText(
                    text: birthChart.palmSummary.toString(),
                    style: medium(fontSize: 16),
                  ),
                  12.h.verticalSpace,
                  AppText(
                    text: "Jupiter mount dominant",
                    style: medium(fontSize: 16),
                  ),
                  32.h.verticalSpace,
                  AppText(
                    text: translator.interpretation,
                    style: semiBold(fontSize: 18.sp, color: AppColors.primary),
                  ),
                  14.h.verticalSpace,
                  AppText(
                    text: birthChart.interpretation,
                    //"Your astrological and palm reading both indicate a favourable period for learning and spiritual growth.",
                    style: medium(fontSize: 16),
                  ),
                  12.h.verticalSpace,
                  AppText(
                    text:
                        "Your astrological and palm reading both indicate a favourable period for learning and spiritual growth.",
                    style: medium(fontSize: 16),
                  ),
                  AppButton(
                    onTap: () {
                      context.pushNamed(
                        MobileAppRoutes.remediesListScreen.name,
                      );
                      provider.getRemedies();
                    },
                    margin: EdgeInsets.only(top: 50.h, bottom: 30.h),
                    title: translator.viewRemedies,
                  ),
                ],
              );
            }
            return ApiLoadingIndicator();
          },
        ),
      ),
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
