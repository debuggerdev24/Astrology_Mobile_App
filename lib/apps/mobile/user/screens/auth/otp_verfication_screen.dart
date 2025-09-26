import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../provider/auth/auth_provider.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String userId;
  const OtpVerificationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<UserAuthProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
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
                      text:
                          "Verify your energy with the stars — enter the code.",
                      style: regular(),
                    ),
                    42.h.verticalSpace,
                    Pinput(
                      controller: provider.otpController,
                      length: 4,
                      separatorBuilder: (index) => 14.w.horizontalSpace,
                      defaultPinTheme: PinTheme(
                        height: 55.h,
                        width: 55.w,
                        textStyle: medium(fontSize: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(05.r),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        height: 55.h,
                        width: 55.w,
                        textStyle: medium(fontSize: 20),
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            8.r,
                          ), // Less Radius
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 2,
                          ),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        height: 55.h,
                        width: 55.w,
                        textStyle: regular(fontSize: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onCompleted: (code) {},
                    ),
                    52.h.verticalSpace,
                    AppButton(
                      title: "Verify",
                      onTap: () {
                        provider.verifyOtp(context: context, userId: userId);
                      },
                    ),
                    8.h.verticalSpace,
                    GestureDetector(
                      onTap:
                          (provider.canResendOtp &&
                              !provider.isResendOtpLoading)
                          ? () {
                              provider.resendOtp(context: context);
                            }
                          : null,
                      child: AppText(
                        text: provider.isResendOtpLoading
                            ? "Resending..."
                            : provider.canResendOtp
                            ? "Resend OTP"
                            : "Resend OTP in ${provider.resendSeconds}s",
                        style: regular(
                          fontSize: 15,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    // AppText(text: "Resend OTP", style: regular(fontSize: 15)),
                  ],
                ),
              ),
              if (provider.isOtpVerificationLoading) FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }
}
