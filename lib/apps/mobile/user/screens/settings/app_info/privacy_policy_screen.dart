import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/text_style.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/global_methods.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.h.verticalSpace,
            topBar(context: context, title: context.translator.privacyPolicy),
            32.h.verticalSpace,
            _section(
              topic: "1. Introduction",
              details:
                  "We respect your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and protect your information when you use our app.",
            ),
            _section(
              topic: "2. Information We Collect",
              details:
                  "Personal Details: Name, email, date of birth, location, and profile details"
                  "App Data: Preferences, activities, and settings within the app."
                  "Device Information: IP address, OS version, device type.",
            ),

            _section(
              topic: "3. How We Use Your Data",
              details:
                  "To provide, personalize, and improve app services"
                  "To send notifications, updates, and offers"
                  "For analytics and troubleshooting.",
            ),
            _section(
              topic: "4. Sharing of Information",
              details:
                  "We do not sell your data. We may share with trusted service providers, legal authorities (if required), or in case of business transfer.",
            ),
            _section(
              topic: "5. Data Storage & Security",
              details:
                  "Your data is stored securely with encryption and access controls.",
            ),
            _section(
              topic: "6. Your Rights",
              details:
                  "You may request access, correction, or deletion of your data at any time.",
            ),
            _section(
              topic: "7. Policy Updates",
              details:
                  "We may update this Privacy Policy. Changes will be posted in the app.",
            ),
            AppText(text: "8. Contact Us", style: medium(fontSize: 20)),
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

  Widget _section({required String topic, required String details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 6.h,
      children: [
        AppText(text: topic, style: medium(fontSize: 20)),
        AppText(
          text: details,
          style: medium(
            fontSize: 18,
            color: AppColors.whiteColor.withValues(alpha: 0.8),
          ),
        ),
        18.h.verticalSpace,
      ],
    );
  }
}
