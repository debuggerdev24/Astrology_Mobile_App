import 'dart:io';

import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/core/enum/app_enums.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../model/settings/subscription_plan_model.dart';

class CurrentPlanScreen extends StatelessWidget {
  const CurrentPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      horizontalPadding: 0,
      body: Column(
        children: [
          40.h.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: topBar(
              context: context,
              title: translator.currentSubscription,
            ),
          ),
          28.h.verticalSpace,
          Consumer<SubscriptionProvider>(
            builder: (context, provider, child) {
              if (!provider.isActivePlanLoading &&
                  provider.activeSubscriptionPlan != null) {
                final activePlan = provider.activeSubscriptionPlan!;

                return greyColoredBox(
                  showShadow: true,
                  width: double.infinity,
                  padding: EdgeInsets.all(14.r),
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: activePlan.plan,
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

                      if (activePlan.plan.toLowerCase() !=
                          AppEnum.free.name) ...[
                        10.verticalSpace,
                        titleWithDetails(
                          title: translator.price,

                          details: "${activePlan.price}",
                        ),
                        titleWithDetails(
                          title: translator
                              .subscriptionDate, //"Subscription date",
                          details: activePlan.startDate,
                        ),
                        titleWithDetails(
                          title: translator
                              .subscriptionValidity, //"Subscription Validity",
                          details: "September 30,2025",
                        ),
                        20.h.verticalSpace,
                        Row(
                          spacing: 10.w,
                          children: [
                            if (activePlan.price != "5 USD")
                              Expanded(
                                child: AppButton(
                                  title: context.translator.upgradePlan,
                                  verticalPadding: 11.h,
                                  onTap: () {
                                    final provider =
                                        Provider.of<SubscriptionProvider>(
                                          context,
                                          listen: false,
                                        );
                                    late SubscriptionPlanModel plan;
                                    if (activePlan.price == "2 USD") {
                                      plan = provider.subscriptionPlans![2];
                                      context.pushNamed(
                                        MobileAppRoutes.selectedPlanScreen.name,
                                        extra: plan,
                                      ); //2000001076716791
                                      //705079220937521237
                                    }
                                  },
                                ),
                              ),
                            if (Platform.isAndroid)
                              Expanded(
                                child: AppButton(
                                  buttonColor: AppColors.secondary,
                                  title: context.translator.cancel,
                                  verticalPadding: 11.h,
                                  onTap: () {
                                    //todo for android
                                    if (Platform.isAndroid) {
                                      final tier =
                                          {
                                            "10": AppEnum.tier1,
                                            "20": AppEnum.tier2,
                                          }[activePlan.price] ??
                                          AppEnum.tier3;
                                      Logger.printInfo(tier.name);
                                      provider.cancelSubscriptionPlan(
                                        context: context,
                                      );
                                      return;
                                    }
                                    //todo for iOS
                                    openManageSubscription();
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
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

  Future<void> openManageSubscription() async {
    final Uri url = Uri.parse(
      Platform.isAndroid
          ? 'https://play.google.com/store/account/subscriptions'
          : 'https://apps.apple.com/account/subscriptions',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
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

  Future<Widget> premiumPlanBox({
    required SubscriptionPlanModel plan,
    required AppLocalizations translator,
    VoidCallback? onTap,
    bool? isFromDetailsScreen,
  }) async {
    return greyColoredBox(
      borderColor: AppColors.primary,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "${plan.plan} :",
                style: bold(
                  fontSize: 20,
                  fontFamily: AppFonts.secondary,
                  color: AppColors.secondary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.secondary,
                ),
              ),
              if (plan.plan.toLowerCase() != AppEnum.free.name)
                AppText(
                  text: "\$${double.parse(plan.price).toStringAsFixed(2)}",
                  style: bold(fontSize: 20, color: AppColors.primary),
                ),
            ],
          ),
          12.h.verticalSpace,
          ...(plan.features as List).map((f) {
            return Row(
              children: [AppText(text: "• $f", style: regular(fontSize: 18))],
            );
          }),
          if (plan.plan.toLowerCase() != AppEnum.free.name)
            Row(
              children: [
                AppText(
                  text: "• ${plan.durationLabel}",
                  style: regular(fontSize: 18),
                ),
              ],
            ),
          if (plan.plan != "Free") ...[
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
