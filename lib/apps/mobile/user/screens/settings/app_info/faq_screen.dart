import 'package:astrology_app/apps/mobile/user/provider/setting/app_info_provider.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/faq_card.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Consumer<AppInfoProvider>(
        builder: (context, provider, child) {
          final faqs = provider.faqs;
          return Column(
            children: [
              40.h.verticalSpace,
              topBar(context: context, title: context.translator.faqS),
              30.h.verticalSpace,
              Expanded(
                child: ListView.separated(
                  itemCount: faqs.length,
                  separatorBuilder: (context, index) => buildDivider(),
                  itemBuilder: (context, index) {
                    return FAQCard(
                      question: faqs[index].question,
                      answer: faqs[index].answer,
                    );
                  },
                ),
              ),

              // FAQCard(
              //   question: "What is this app used for?",
              //   answer:
              //       "This app helps users easily book consultations, explore remedies, and access premium health-related resources from certified experts.",
              // ),
              // buildDivider(),
              // FAQCard(
              //   question: "What is this app used for?",
              //   answer:
              //       "This app helps users easily book consultations, explore remedies, and access premium health-related resources from certified experts.",
              // ),
              // buildDivider(),
              // FAQCard(
              //   question: "What is this app used for?",
              //   answer:
              //       "This app helps users easily book consultations, explore remedies, and access premium health-related resources from certified experts.",
              // ),
            ],
          );
        },
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
