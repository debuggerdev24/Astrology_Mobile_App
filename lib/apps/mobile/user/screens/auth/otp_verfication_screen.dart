import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';

TextEditingController otpController = TextEditingController();

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      horizontalPadding: 16.w,
      topPadding: 32.h,
      body: Column(
        children: [
          40.h.verticalSpace,
          AppText(
            text: "Enter 4-Digit Code",
            textAlign: TextAlign.center,
            style: bold(
              height: 1.1,
              fontFamily: AppFonts.secondary,
              fontSize: 42,
            ),
          ),
          12.h.verticalSpace,
          AppText(
            textAlign: TextAlign.center,
            text: "Verify your energy with the stars — enter the code.",
            style: regular(),
          ),
          42.h.verticalSpace,
          Pinput(
            controller: otpController,
            length: 4,
            defaultPinTheme: PinTheme(
              height: 55.h,
              width: 55.w,
              textStyle: bold(fontSize: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(05.r),
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
            focusedPinTheme: PinTheme(
              height: 55.h,
              width: 55.w,
              textStyle: bold(fontSize: 18),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(8.r), // Less Radius
                border: Border.all(color: AppColors.whiteColor, width: 2),
              ),
            ),
            submittedPinTheme: PinTheme(
              height: 55.h,
              width: 55.w,
              textStyle: bold(fontSize: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
            keyboardType: TextInputType.number,
            onCompleted: (code) {},
          ),
          52.h.verticalSpace,
          AppButton(title: "Verify"),
          8.h.verticalSpace,
          AppText(text: "Resend OTP", style: regular(fontSize: 15)),
        ],
      ),
    );
  }
}
