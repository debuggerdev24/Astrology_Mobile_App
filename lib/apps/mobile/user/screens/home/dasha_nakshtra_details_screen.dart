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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.h.verticalSpace,
            topBar(
              context: context,
              title: "${translator.dasha}/${translator.nakshatra}",
            ),
            40.h.verticalSpace,
            ...topicDetails(topic: translator.career, details: details.career),
            ...topicDetails(
              topic: translator.relationships,
              details: details.relationships,
            ),
            ...topicDetails(topic: translator.health, details: details.health),
            ...topicDetails(
              topic: translator.finance,
              details: details.finance,
            ),
            ...topicDetails(
              topic: translator.spirituality,
              details: details.spirituality,
            ),
          ],
        ),
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
