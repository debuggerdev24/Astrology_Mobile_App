import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';

TextEditingController _txtEmail = TextEditingController();

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              height: 1.2,
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
            controller: _txtEmail,
            title: "Name",
            hintText: "Enter Your Email",
          ),
          52.h.verticalSpace,
          AppButton(
            title: "Send Mail",
            onTap: () {
              context.pushNamed(MobileAppRoutes.otpScreen.name);
            },
          ),
        ],
      ),
    );
  }
}
