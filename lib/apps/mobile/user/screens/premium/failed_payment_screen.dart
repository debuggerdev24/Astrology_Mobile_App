import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/global_methods.dart';
import '../../../../../core/widgets/svg_image.dart';

class FailedPaymentScreen extends StatelessWidget {
  const FailedPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(
            context: context,
            title: "Payment Failed",
            showBackButton: false,
          ),
          80.h.verticalSpace,
          SVGImages(path: AppAssets.failedPayment),
          65.h.verticalSpace,
          AppText(
            textAlign: TextAlign.center,
            text: "Payment Was Failed!",
            style: bold(fontSize: 22.sp),
          ),
          Spacer(),
          AppButton(
            title: "Try Again",
            margin: EdgeInsets.only(bottom: 30.h),
          ),
        ],
      ),
    );
  }
}
