import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserAuthProvider>();
    return AppLayout(
      horizontalPadding: 16.w,
      body: Column(
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
            text: "Even stars lose their way — let's help you reset yours.",
            style: regular(),
          ),
          32.h.verticalSpace,

          AppTextField(
            controller: provider.forgotEmailCtr,
            title: "Email",
            hintText: "Enter Your Email",
            errorMessage: provider.forgotEmailErr,
          ),
          52.h.verticalSpace,
          AppButton(
            title: "Send Mail",
            onTap: () {
              provider.forgotPassword(context);
              // context.pushNamed(MobileAppRoutes.verifyOtpScreen.name);
            },
          ),
        ],
      ),
    );
  }
}
