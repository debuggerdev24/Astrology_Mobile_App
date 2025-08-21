import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
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
    return AppLayout(
      body: SingleChildScrollView(
        child: Consumer<UserAuthProvider>(
          builder: (context, provider, child) => Column(
            children: [
              40.h.verticalSpace,
              topBar(context: context, title: "Reset Password"),
              35.h.verticalSpace,
              AppTextField(
                controller: provider.resetNewPassCtr,
                title: "New Password",
                hintText: "Enter your New Password",
                errorMessage: provider.resetNewPassErr,
              ),
              22.h.verticalSpace,
              AppTextField(
                controller: provider.resetConfirmPassCtr,
                title: "Confirm Password",
                hintText: "Enter Confirm Password",
                errorMessage: provider.resetConfirmPassErr,
              ),
              AppButton(
                onTap: () {
                  provider.resetPassword(context: context, userId: userId);
                },
                title: "Reset Password",
                margin: EdgeInsets.only(top: 50.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
