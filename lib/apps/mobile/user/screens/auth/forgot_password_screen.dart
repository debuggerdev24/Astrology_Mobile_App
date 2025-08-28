import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';

TextEditingController _sendOTPEmail = TextEditingController();

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    _sendOTPEmail.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<UserAuthProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  40.h.verticalSpace,
                  AppText(
                    textAlign: TextAlign.center,
                    text: "Forgot Password",
                    style: bold(
                      fontFamily: AppFonts.secondary,
                      fontSize: 46,
                      height: 1.1,
                    ),
                  ),
                  14.h.verticalSpace,
                  AppText(
                    textAlign: TextAlign.center,
                    text:
                        "Even stars lose their way — let's help you reset yours.",
                    style: regular(),
                  ),
                  32.h.verticalSpace,

                  AppTextField(
                    controller: _sendOTPEmail,
                    title: "Email",
                    hintText: "Enter Your Email",
                    errorMessage: provider.forgotEmailErr,
                  ),
                  52.h.verticalSpace,
                  AppButton(
                    title: "Send Mail",
                    onTap: () {
                      deBouncer.run(
                        () => provider.sendOtp(
                          context: context,
                          email: _sendOTPEmail.text.trim(),
                        ),
                      );
                      // context.pushNamed(MobileAppRoutes.verifyOtpScreen.name);
                    },
                  ),
                ],
              ),
            ),
            if (provider.isSendOtpLoading) ApiLoadingFullPageIndicator(),
          ],
        ),
      ),
    );
  }
}
