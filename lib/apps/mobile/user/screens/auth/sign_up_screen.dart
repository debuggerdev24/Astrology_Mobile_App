import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_layout.dart';

TextEditingController _txtName = TextEditingController();
TextEditingController _txtEmail = TextEditingController();
TextEditingController _txtPassword = TextEditingController();
TextEditingController _txtConfirmPassword = TextEditingController();

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      horizontalPadding: 16.w,
      body: SingleChildScrollView(
        child: Column(
          children: [
            40.h.verticalSpace,
            AppText(
              text: "Sign Up",
              style: bold(fontFamily: AppFonts.secondary, fontSize: 46),
            ),
            12.h.verticalSpace,
            AppText(
              textAlign: TextAlign.center,
              text: "Unlock personalized astrological insights just for you.",
              style: regular(),
            ),
            32.h.verticalSpace,
            Column(
              spacing: 22.h,
              children: [
                AppTextField(
                  controller: _txtName,
                  title: "Name",
                  hintText: "Enter Your Name",
                ),
                AppTextField(
                  controller: _txtName,
                  title: "Name",
                  hintText: "Enter Your Name",
                ),
                AppTextField(
                  controller: _txtName,
                  title: "Password",
                  hintText: "Enter Your Name",
                ),
                AppTextField(
                  controller: _txtName,
                  title: "Confirm Password",
                  hintText: "Enter Your Name",
                ),
              ],
            ),
            AppButton(
              title: "Sign Up",
              margin: EdgeInsets.only(top: 52.h, bottom: 8.h),
            ),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                context.pushNamed(MobileAppRoutes.signInScreen.name);
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: regular(fontSize: 15, fontFamily: "Primary"),
                    ),
                    TextSpan(
                      text: "Sign In",
                      style: semiBold(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontFamily: "Primary",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            48.h.verticalSpace,
          ],
        ),
      ),
    );
  }
}
