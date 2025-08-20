import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/faq_card.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: context.translator.faqS),
          30.h.verticalSpace,
          FAQCard(
            question: "What is this app used for?",
            answer:
                "This app helps users easily book consultations, explore remedies, and access premium health-related resources from certified experts.",
          ),
          buildDivider(),
          FAQCard(
            question: "What is this app used for?",
            answer:
                "This app helps users easily book consultations, explore remedies, and access premium health-related resources from certified experts.",
          ),
          buildDivider(),
          FAQCard(
            question: "What is this app used for?",
            answer:
                "This app helps users easily book consultations, explore remedies, and access premium health-related resources from certified experts.",
          ),
          buildDivider(),
          FAQCard(
            question: "What is this app used for?",
            answer:
                "This app helps users easily book consultations, explore remedies, and access premium health-related resources from certified experts.",
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Divider(color: AppColors.whiteColor.withValues(alpha: 0.3)),
    );
  }
}
