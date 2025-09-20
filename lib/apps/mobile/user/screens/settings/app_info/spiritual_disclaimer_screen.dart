import 'package:astrology_app/apps/mobile/user/provider/setting/app_info_provider.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/app_layout.dart';
import '../../../../../../core/widgets/global_methods.dart';

class SpiritualDisclaimerScreen extends StatefulWidget {
  const SpiritualDisclaimerScreen({super.key});

  @override
  State<SpiritualDisclaimerScreen> createState() =>
      _SpiritualDisclaimerScreenState();
}

class _SpiritualDisclaimerScreenState extends State<SpiritualDisclaimerScreen> {
  @override
  void initState() {
    // context.read<AppInfoProvider>().getSpiritualDisclaimers(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.h.verticalSpace,
          topBar(
            context: context,
            title: context.translator.spiritualDisclaimers,
          ),

          20.h.verticalSpace,
          Expanded(
            child: Consumer<AppInfoProvider>(
              builder: (context, provider, child) {
                final sd = provider.spiritualDisclaimers;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: sd.length,
                  itemBuilder: (context, index) {
                    return _section(
                      topic: sd[index].topic,
                      details: sd[index].details,
                    );
                  },
                );
              },
            ),
          ),
          // _section(
          //   topic: "Purpose",
          //   details:
          //       "This app offers spiritual insight and self-reflection through astrology, palmistry, numerology, and related tools. The guidance provided is interpretive and should not be viewed as absolute truth.",
          // ),
          // _section(
          //   topic: "Scope of Services:",
          //   details:
          //       "Content is based on ancient spiritual systems and is not backed by scientific validation. Outcomes may vary based on personal factors such as free will and lifestyle.",
          // ),
          //
          // _section(
          //   topic: "Not a Substitute for Professional Advice:",
          //   details:
          //       "Our app does not offer medical, legal, financial, or psychological advice. For such matters, consult a qualified professional.",
          // ),
          // _section(
          //   topic: "Personal Responsibility:",
          //   details:
          //       "You are solely responsible for how you use the app’s content. We are not liable for any decisions or outcomes based on this guidance.",
          // ),
          // _section(
          //   topic: "Limitations:",
          //   details:
          //       "Spiritual interpretations are subjective and culturally influenced. We cannot guarantee complete accuracy of readings or predictions.",
          // ),
          // _section(
          //   topic: "Consent:",
          //   details:
          //       "By using this app, you agree to this disclaimer. Our services are for spiritual growth, entertainment, and self-reflection—not legally binding commitments.",
          // ),
        ],
      ),
    );
  }

  Widget _section({required String topic, required String details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 10.h,
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
