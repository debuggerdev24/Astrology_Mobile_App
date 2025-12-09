import 'package:astrology_app/apps/mobile/user/model/settings/subscription_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/enum/app_enums.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
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
            child: topBar(context: context, title: translator.chooseYourPlan),
          ),
          6.h.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 20.h,
                children: [
                  SizedBox(),
                  Consumer<SubscriptionProvider>(
                    builder: (context, provider, child) {
                      if (provider.isPlansLoading) {
                        return _shimmer();
                      }
                      return Column(
                        children: List.generate(
                          provider.subscriptionPlans!.length,
                          (index) {
                            final plan = provider.subscriptionPlans![index];
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
                          },
                        ),
                      );
                    },
                  ),
                  AppButton(
                    onTap: () {
                      context.pushNamed(MobileAppRoutes.currentPlanScreen.name);
                    },
                    buttonColor: AppColors.secondary,
                    title: translator.currentSubscription,
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

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor,
      highlightColor: Colors.grey[400]!,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.h.verticalSpace,
              // ---------------- Top Bar Placeholder ----------------
              Row(
                children: [
                  Container(
                    width: 200.w,
                    height: 28.h,

                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              16.h.verticalSpace,

              // ---------------- Dasha & Moon Section ----------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.greyColor,
                    ),
                  ),
                  6.h.verticalSpace,
                  Container(
                    width: 100.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.greyColor,
                    ),
                  ),
                  4.h.verticalSpace,
                  Container(
                    width: 120.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
              16.h.verticalSpace,
              // ---------------- Today Mantra Card ----------------
              Container(
                width: double.infinity,
                height: 110.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              16.h.verticalSpace,

              // ---------------- Karma Focus Box ----------------
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    3,
                    (_) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.h),
                      child: Container(
                        width: double.infinity,
                        height: 20.h,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                ),
              ),
              16.h.verticalSpace,

              // ---------------- Dasha Nakshatra Box ----------------
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    4,
                    (_) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.h),
                      child: Container(
                        width: double.infinity,
                        height: 20.h,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                ),
              ),
              20.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

Widget premiumPlanBox({
  required SubscriptionPlanModel plan,
  required AppLocalizations translator,
  VoidCallback? onTap,
  bool? isFromDetailsScreen,
}) {
  return greyColoredBox(
    showShadow: true,
    borderColor: isFromDetailsScreen ?? false ? AppColors.primary : null,
    margin: EdgeInsets.only(bottom: 16.h, left: 12.w, right: 12.w),
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
            if (plan.price != "0")
              AppText(
                text: plan.price, //"\$${double.parse().toStringAsFixed(2)}",
                style: bold(fontSize: 18, color: AppColors.primary),
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
        if (!(isFromDetailsScreen ?? false) && plan.price != "0") ...[
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
