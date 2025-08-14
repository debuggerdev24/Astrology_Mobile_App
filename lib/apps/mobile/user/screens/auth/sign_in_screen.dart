import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';

TextEditingController _txtEmail = TextEditingController();
TextEditingController _txtPassword = TextEditingController();

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      horizontalPadding: 16.w,
      body: Column(
        children: [
          40.h.verticalSpace,
          AppText(
            text: "Sign Up",
            style: bold(fontFamily: AppFonts.secondary, fontSize: 46.sp),
          ),
          12.h.verticalSpace,
          AppText(
            textAlign: TextAlign.center,
            text: "Reconnect with your cosmic journey.",
            style: regular(),
          ),
          32.h.verticalSpace,
          Column(
            spacing: 22.h,
            children: [
              AppTextField(
                controller: _txtEmail,
                title: "Name",
                hintText: "Enter Your Email",
              ),
              AppTextField(
                controller: _txtPassword,
                title: "Name",
                hintText: "Enter Your Password",
              ),
            ],
          ),
          6.h.verticalSpace,
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(MobileAppRoutes.forgotPasswordScreen.name);
              },
              child: AppText(
                text: "Forgot Password?",
                style: regular(fontSize: 12.sp),
              ),
            ),
          ),
          52.h.verticalSpace,
          AppButtonPrimary(
            title: "Sign In",
            onTap: () {
              context.pushNamed(MobileAppRoutes.userDashBoardScreen.name);
            },
          ),
          8.h.verticalSpace,
          GestureDetector(
            onTap: () {
              // removeFocusFromAllFiled();
              context.pop();
            },
            child: RichText(
              text: TextSpan(
                //Login with email, when email is found in system
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: regular(fontSize: 15.sp, fontFamily: "Primary"),
                  ),
                  TextSpan(
                    text: "Sign Up",
                    style: semiBold(
                      fontSize: 15.sp,
                      color: AppColors.primary,
                      fontFamily: "Primary",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
