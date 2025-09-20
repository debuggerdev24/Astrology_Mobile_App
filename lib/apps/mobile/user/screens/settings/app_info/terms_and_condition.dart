import 'package:astrology_app/apps/mobile/user/provider/setting/app_info_provider.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.h.verticalSpace,
            topBar(context: context, title: "Terms & Conditions"),
            30.h.verticalSpace,
            // AppText(
            //   text:
            //       "By using this app, you agree to follow our Terms & Conditions and Privacy Policy. Please stop using the app if you don’t agree."
            //       "\n\nYou must be 18+ or have parental consent. You’re responsible for the accuracy of your submitted birth or palm data."
            //       "\n\nCreating an account may be required. Keep your login info secure; you’re responsible for all activity on your account."
            //       "\n\nDon’t use the app for illegal purposes, share false data, or copy content without permission."
            //       "\n\nPremium features require payment via Stripe. Subscriptions renew automatically unless canceled in time."
            //       "\n\nYou can book sessions with spiritual consultants. We don’t guarantee specific results or outcomes from these sessions."
            //       "\n\nAll app content (text, images, audio, etc.) is protected and owned/licensed by us. Don’t copy or share without permission."
            //       "\n\nOur insights are spiritual and subjective—not scientifically proven. Use at your own discretion."
            //       "\n\nWe’re not responsible for any damages or losses resulting from app use."
            //       "\n\nWe may update these Terms. Continued use means you accept the new version."
            //       "\n\nWe can suspend or remove your account if you misuse the app. You can cancel anytime."
            //       "\n\nThese Terms follow the laws of India",
            //   style: medium(
            //     fontSize: 18,
            //     color: AppColors.whiteColor.withValues(alpha: 0.8),
            //   ),
            // ),
            Consumer<AppInfoProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: List.generate(provider.termsAndCondition.length, (
                    index,
                  ) {
                    return AppText(
                      text: "${provider.termsAndCondition[index]["content"]}\n",
                      style: medium(
                        fontSize: 18,
                        color: AppColors.whiteColor.withValues(alpha: 0.8),
                      ),
                    );
                  }),
                );
              },
            ),
            AppText(
              text: "These Terms follow the laws of India.",
              style: medium(
                fontSize: 18,
                color: AppColors.whiteColor.withValues(alpha: 0.8),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'admin@gmail.com',
                );

                await launchUrl(emailUri, mode: LaunchMode.externalApplication);
              },
              child: AppText(
                text: "\nFor questions, email us at:\nadmin@gmail.com",
                style: medium(
                  fontSize: 18,
                  color: AppColors.whiteColor.withValues(alpha: 0.8),
                ),
              ),
            ),

            18.h.verticalSpace,
          ],
        ),
      ),
    );
  }
}
