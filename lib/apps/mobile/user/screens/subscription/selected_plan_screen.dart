import 'package:astrology_app/apps/mobile/user/model/settings/subscription_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/screens/subscription/choose_plan_screen.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/enum/app_enums.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../services/subscription/subscription_service.dart';

class SelectedPlanScreen extends StatelessWidget {
  final SubscriptionPlanModel plan;
  const SelectedPlanScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: plan.plan),
          24.h.verticalSpace,

          premiumPlanBox(
            plan: plan,
            isFromDetailsScreen: true,
            translator: translator,
          ),
          Spacer(),
          AppButton(
            margin: EdgeInsets.only(bottom: 12.h),
            buttonColor: AppColors.secondary,
            title: translator.cancel,
            onTap: () {
              context.pop();
            },
          ),
          AppButton(
            margin: EdgeInsets.only(bottom: 30.h),
            title: translator.payAndSubscribe,
            onTap: () async {
              var selectedPlan = AppEnum.tier1;
              if (plan.id == 3) {
                selectedPlan = AppEnum.tier2;
              } else if (plan.id == 4) {
                selectedPlan = AppEnum.tier3;
              }
              Logger.printInfo(selectedPlan.name);
              await SubscriptionService().buySubscription(tier: selectedPlan);
              // context.pushNamed(MobileAppRoutes.paymentDetailScreen.name);
            },
          ),
        ],
      ),
    );
  }
}
