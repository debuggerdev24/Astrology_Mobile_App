import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/utils/de_bouncing.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      horizontalPadding: 0,
      body: SingleChildScrollView(
        child: Consumer<UserAuthProvider>(
          builder: (context, provider, child) => Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    40.h.verticalSpace,
                    AppText(
                      text: translator.signIn,
                      style: bold(fontFamily: AppFonts.secondary, fontSize: 46),
                    ),
                    12.h.verticalSpace,
                    AppText(
                      textAlign: TextAlign.center,
                      text: translator.signInSlogan,
                      style: regular(),
                    ),
                    32.h.verticalSpace,
                    Column(
                      spacing: 22.h,
                      children: [
                        AppTextField(
                          controller: provider.loginEmailCtr,
                          title: translator.email,
                          hintText: translator.enterYourEmail,
                          errorMessage: provider.loginEmailErr,
                        ),
                        AppTextField(
                          controller: provider.loginPassCtr,
                          title: translator.password,
                          hintText: translator.enterYourPassword,
                          errorMessage: provider.loginPassErr,
                        ),
                      ],
                    ),
                    6.h.verticalSpace,
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            MobileAppRoutes.forgotPasswordScreen.name,
                          );
                        },
                        child: AppText(
                          text: "${translator.forgotPass} ?",
                          style: regular(fontSize: 13.5),
                        ),
                      ),
                    ),
                    52.h.verticalSpace,
                    AppButton(
                      title: translator.signIn,
                      onTap: () {
                        deBouncer.run(() {
                          provider.loginUser(context);
                        });
                        // context.pushNamed(MobileAppRoutes.resetPasswordScreen.name);
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
                              text: "${translator.dontHaveAcc} ",
                              style: regular(
                                fontSize: 15.sp,
                                fontFamily: "Primary",
                              ),
                            ),
                            TextSpan(
                              text: "${translator.signUp}",
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
              ),
              if (provider.isLoginLoading) FullPageIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
