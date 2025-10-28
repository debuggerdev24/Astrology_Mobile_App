import 'package:astrology_app/apps/mobile/user/model/home/daily_horo_scope_model.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/global_methods.dart';

class DashaNakshtraDetailsScreen extends StatelessWidget {
  final DailyHoroScopeModel dailyHoroScope;
  const DashaNakshtraDetailsScreen({super.key, required this.dailyHoroScope});

  @override
  Widget build(BuildContext context) {
    final details = dailyHoroScope.detailedPredictions;
    final translator = context.translator;
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(
            context: context,
            title: "${translator.dasha}/${translator.nakshatra}",
          ),
          28.h.verticalSpace,
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...topicDetails(
                  topic: translator.familyEnergy,
                  details: details.familyEnergy,
                ),
                ...topicDetails(
                  topic: translator.powerPeriods,
                  details: details.powerPeriods,
                ),
                ...topicDetails(
                  topic: translator.emotionalEnergy,
                  details: details.emotionalEnergy,
                ),
                ...topicDetails(
                  topic: translator.learningOutlook,
                  details: details.learningOutlook,
                ),
                ...topicDetails(
                  topic: translator.spiritualEnergy,
                  details: details.spiritualEnergy,
                ),
                ...topicDetails(
                  topic: translator.planetarySnapshot,
                  details: details.planetarySnapshot,
                ),
                ...topicDetails(
                  topic: translator.summary,
                  details: details.summary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> topicDetails({required String topic, required String details}) {
    return [
      AppText(
        text: topic,
        style: semiBold(fontSize: 18, color: AppColors.primary),
      ),
      6.h.verticalSpace,
      AppText(text: details, style: medium(fontSize: 16)),
      16.h.verticalSpace,
    ];
  }
}
