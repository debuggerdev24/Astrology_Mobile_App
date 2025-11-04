import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/app_layout.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    Logger.printInfo(context.isTamil.toString());
    return AppLayout(
      horizontalPadding: 0,
      body: SingleChildScrollView(
        child: Consumer<UserAuthProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      40.h.verticalSpace,
                      AppText(
                        text: translator.signUp,
                        style: bold(
                          fontFamily: AppFonts.secondary,
                          fontSize: context.isTamil ? 40 : 44,
                        ),
                      ),
                      12.h.verticalSpace,
                      AppText(
                        textAlign: TextAlign.center,
                        text: translator.signUpSlogan,
                        style: regular(),
                      ),
                      32.h.verticalSpace,
                      Column(
                        spacing: 22.h,
                        children: [
                          AppTextField(
                            controller: provider.registerNameCtr,
                            title: translator.name,
                            hintText: translator.enterYourName,
                            errorMessage: provider.registerNameErr,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                          ),
                          AppTextField(
                            controller: provider.registerEmailCtr,
                            title: translator.email,
                            hintText: translator.enterYourEmail,
                            errorMessage: provider.registerEmailErr,
                          ),
                          AppTextField(
                            controller: provider.registerPasswordCtr,
                            title: translator.password,
                            hintText: translator.enterYourPassword,
                            errorMessage: provider.registerPasswordErr,
                          ),
                          AppTextField(
                            controller: provider.registerConfirmPassCtr,
                            title: translator.confirmPassword,
                            hintText: translator.enterYourConfirmPassword,
                            errorMessage: provider.registerConfirmPassWordErr,
                          ),
                        ],
                      ),
                      AppButton(
                        onTap: () {
                          deBouncer.run(() {
                            provider.registerUser(context);
                          });
                        },
                        title: translator.signUp,
                        margin: EdgeInsets.only(top: 52.h, bottom: 8.h),
                      ),
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          provider.clearRegisterField();
                          provider.clearRegisterErrors();
                          context.pushNamed(MobileAppRoutes.signInScreen.name);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: translator.alreadyHaveAcc,
                                style: regular(
                                  fontSize: 15,
                                  fontFamily: "Primary",
                                ),
                              ),
                              TextSpan(
                                text: " ${translator.signIn}",
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
                if (provider.isRegisterLoading) FullPageIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
