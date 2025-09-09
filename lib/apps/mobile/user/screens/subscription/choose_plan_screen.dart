import 'package:astrology_app/apps/mobile/user/model/settings/subscription_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
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

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  @override
  void initState() {
    context.read<SubscriptionProvider>().getActiveSubscriptionPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;

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
                  Consumer<SubscriptionProvider>(
                    builder: (context, provider, child) => Column(
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
                    ),
                  ),
                  AppButton(
                    onTap: () {
                      // context
                      //     .read<SubscriptionProvider>()
                      //     .getActiveSubscriptionPlan();

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
}

Widget premiumPlanBox({
  required SubscriptionPlanModel plan,
  required AppLocalizations translator,
  VoidCallback? onTap,
  bool? isFromDetailsScreen,
}) {
  return greyColoredBox(
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(14.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: plan.plan,
              style: bold(
                fontSize: 20,
                fontFamily: AppFonts.secondary,
                color: AppColors.secondary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.secondary,
              ),
            ),
            if (plan.plan != "Free")
              AppText(
                text: "\$${plan.price.toString()}",
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

        Row(
          children: [
            AppText(
              text: "• ${plan.durationLabel}",
              style: regular(fontSize: 18),
            ),
          ],
        ),
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
