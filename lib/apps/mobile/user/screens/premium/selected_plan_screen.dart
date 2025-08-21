import 'package:astrology_app/apps/mobile/user/screens/premium/premium_plan_screen.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SelectedPlanScreen extends StatelessWidget {
  final Map<String, dynamic> plan;
  const SelectedPlanScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: plan["title"]),
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
            onTap: () {
              context.pushNamed(MobileAppRoutes.paymentDetailScreen.name);
            },
          ),
        ],
      ),
    );
  }
}
