import 'package:astrology_app/apps/mobile/user/screens/app_tutorial/app_tour.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RemediesScreenTour extends StatefulWidget {
  const RemediesScreenTour({super.key});

  @override
  State<RemediesScreenTour> createState() => _RemediesScreenTourState();
}

class _RemediesScreenTourState extends State<RemediesScreenTour> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });
    super.initState();
  }

  void _showTutorial() {
    // Check your existing shared prefs here
    // if (!yourSharedPrefs.hasSeenPalmUploadTutorial) {
    AppTourManager.showRemedyTutorial(
      context: context,
      onFinish: () {
        // Save to your shared prefs
        // yourSharedPrefs.setPalmUploadTutorialSeen();

        context.pushNamed(MobileAppRoutes.profileScreenTour.name);
      },
      onSkip: () {
        context.goNamed(MobileAppRoutes.userDashBoardScreen.name, extra: true);

        // Save to your shared prefs
        // yourSharedPrefs.setPalmUploadTutorialSeen();
      },
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: translator.remedies),
          8.h.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  8.h.verticalSpace,
                  SizedBox(
                    key: AppTourKeys.remediesKey,
                    child: buildRemedySection(
                      translator: translator,
                      title: "Planet",
                      context: context,
                    ),
                  ),
                  buildRemedySection(
                    translator: translator,
                    title: "Dasha",
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRemedySection({
    required AppLocalizations translator,
    required String title,
    required BuildContext context,
  }) {
    return greyColoredBox(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: title, //translator.planet
            style: bold(
              fontSize: 20,
              fontFamily: AppFonts.secondary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.tealColor,
              color: AppColors.tealColor,
            ),
          ),
          16.h.verticalSpace,
          AppText(
            text: "SUN REMEDY – Leadership & Con-fidence",
            style: medium(fontSize: 16),
          ),
          10.h.verticalSpace,
          topicWithDetails(
            topic: translator.type,
            details: "Donation + Chanting",
          ),
          topicWithDetails(
            topic: translator.description,
            details: "Repeating mantras for specific energies",
          ),
          AppButton(
            onTap: () {
              context.pushNamed(MobileAppRoutes.profileScreenTour.name);
            },
            margin: EdgeInsets.only(top: 18),
            title: translator.viewDetails,
            fontSize: 14.sp,
          ),
        ],
      ),
    );
  }

  Widget topicWithDetails({required String topic, required String details}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        spacing: 4,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.5),

            child: AppText(text: topic, style: regular(fontSize: 16)),
          ),
          AppText(text: ":", style: regular(fontSize: 16)),
          Expanded(
            flex: 3,
            child: AppText(text: details, style: regular(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
