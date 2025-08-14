import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/text_style.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/global_methods.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: context.translator.appInfo),
          32.h.verticalSpace,
          _section(title: context.translator.privacyPolicy, onTap: () {}),
          buildDivider(),
          _section(
            title: context.translator.spiritualDisclaimers,
            onTap: () {},
          ),
          buildDivider(),
          _section(title: context.translator.faqS, onTap: () {}),
          buildDivider(),
          _section(title: context.translator.termsAndConditions, onTap: () {}),
        ],
      ),
    );
  }

  Widget buildDivider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Divider(color: AppColors.whiteColor.withValues(alpha: 0.6)),
  );

  Widget _section({required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: AppText(
        text: title,
        style: medium(fontSize: 18.sp),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18.sp,
        color: AppColors.white,
      ),
    );
  }
}
