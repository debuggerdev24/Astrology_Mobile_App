import 'package:astrology_app/apps/mobile/user/model/settings/subscription_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/subscription/choose_plan_screen.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/enum/app_enums.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/custom_toast.dart';

class SelectedPlanScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;
  const SelectedPlanScreen({super.key, required this.plan});

  @override
  State<SelectedPlanScreen> createState() => _SelectedPlanScreenState();
}

class _SelectedPlanScreenState extends State<SelectedPlanScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().setSubscriptionProcessStatus(
        status: false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  40.h.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: topBar(context: context, title: widget.plan.plan),
                  ),
                  24.h.verticalSpace,
                  premiumPlanBox(
                    plan: widget.plan,
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
                      deBouncer.run(() async {
                        if (widget.plan.price == "5 USD" &&
                            provider.isTier2Subscribed) {
                          AppToast.info(
                            context: context,
                            message: context.translator.alreadySubscribedTier2,
                            // "You’ve already subscribed to the Tier 2.",
                          );
                          return;
                        }
                        if (widget.plan.price == "2 USD" &&
                            provider.isTier1Subscribed) {
                          AppToast.info(
                            context: context,
                            message: context.translator.alreadySubscribedTier1,
                          );
                          return;
                        }
                        var selectedPlan = AppEnum.tier1;
                        if (widget.plan.id == 3) {
                          selectedPlan = AppEnum.tier2;
                        } else if (widget.plan.id == 4) {
                          selectedPlan = AppEnum.tier3;
                        }
                        Logger.printInfo(selectedPlan.name);

                        await provider.buySubscription(
                          tier: selectedPlan,
                          planId: widget.plan.id,
                          context: context,
                        );
                      });
                    },
                  ),
                ],
              ),
              if (provider.isSubscriptionLoading) FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }
}
