import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
          Consumer<SubscriptionProvider>(
            builder: (context, provider, child) {
              if (!provider.isActivePlanLoading &&
                  provider.activeSubscriptionPlan != null) {
                final activePlan = provider.activeSubscriptionPlan;
                return greyColoredBox(
                  padding: EdgeInsets.all(14.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: activePlan!.plan,
                        style: bold(
                          fontSize: 20,
                          fontFamily: AppFonts.secondary,
                          color: AppColors.secondary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.secondary,
                        ),
                      ),
                      12.h.verticalSpace,
                      ...List.generate(activePlan.features.length, (index) {
                        return AppText(
                          text: "• ${activePlan.features[index]}",
                          style: regular(fontSize: 18),
                        );
                      }),

                      20.h.verticalSpace,
                      titleWithDetails(
                        title: "Price",
                        details: "\$${activePlan.price}",
                      ),
                      titleWithDetails(
                        title: "Subscription date",
                        details: formatDate(
                          DateTime.parse(activePlan.startDate),
                        ), //"August 13, 2024",
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
                              buttonColor: AppColors.secondary,
                              title: context.translator.cancel,
                              verticalPadding: 11.h,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (provider.isActivePlanLoading) {
                return Expanded(
                  child: Center(
                    child: AppText(text: "No active subscription found!."),
                  ),
                );
              } else {
                return Expanded(child: ApiLoadingIndicator());
              }
            },
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
          flex: 3,
          child: AppText(text: details, style: regular(fontSize: 18)),
        ),
      ],
    );
  }
}

//
String formatDate(DateTime date) {
  const List<String> monthNames = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String month = monthNames[date.month - 1];
  String day = date.day.toString();
  String year = date.year.toString();

  return '$day $month, $year';
}
