import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PaymentDetailScreen extends StatelessWidget {
  const PaymentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: translator.upgradePlan),
          24.h.verticalSpace,
          AppText(
            text: "${translator.choosePaymentMethod} : ",
            style: medium(fontSize: 18),
          ),
          24.h.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Credit card or Debit card",
                style: medium(fontSize: 16),
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          AppButton(
            onTap: () {
              context.pushNamed(MobileAppRoutes.successPaymentScreen.name);
            },
            margin: EdgeInsets.only(bottom: 30.h),
            title: translator.payNow,
          ),
        ],
      ),
    );
  }
}
