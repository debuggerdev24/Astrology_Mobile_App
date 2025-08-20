import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SuccessPaymentScreen extends StatelessWidget {
  const SuccessPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(
            context: context,
            title: "Payment Confirmation",
            showBackButton: false,
          ),
          80.h.verticalSpace,
          SVGImage(path: AppAssets.successPayment),
          65.h.verticalSpace,
          AppText(
            textAlign: TextAlign.center,
            text: "Payment Was Successful\nThanks!",
            style: bold(fontSize: 22.sp),
          ),
          Spacer(),
          AppButton(
            onTap: () {
              context.pushNamed(MobileAppRoutes.failedPaymentScreen.name);
            },
            title: "Done",
            margin: EdgeInsets.only(bottom: 30.h),
          ),
        ],
      ),
    );
  }
}
