import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String userId;
  const ResetPasswordScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<UserAuthProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    40.h.verticalSpace,
                    topBar(context: context, title: translator.resetPassword),
                    35.h.verticalSpace,
                    AppTextField(
                      controller: provider.resetNewPassCtr,
                      title: translator.newPassword,
                      hintText: translator.enterYourNewPass,
                      errorMessage: provider.resetNewPassErr,
                    ),
                    22.h.verticalSpace,

                    AppTextField(
                      controller: provider.resetConfirmPassCtr,
                      title: translator.confirmPassword,
                      hintText: translator.enterYourConfirmPassword,
                      errorMessage: provider.resetConfirmPassErr,
                    ),
                    AppButton(
                      onTap: () {
                        deBouncer.run(() {
                          provider.resetPassword(
                            context: context,
                            userId: userId,
                          );
                        });
                      },
                      title: translator.resetPassword,
                      margin: EdgeInsets.only(top: 50.h),
                    ),
                  ],
                ),
              ),
            ),
            if (provider.isResetPasswordLoading) FullPageIndicator(),
          ],
        ),
      ),
    );
  }
}
