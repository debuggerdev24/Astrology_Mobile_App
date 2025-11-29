import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/text_style.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/global_methods.dart';
import 'app_tour.dart';

class AppInfoTour extends StatefulWidget {
  const AppInfoTour({super.key});

  @override
  State<AppInfoTour> createState() => _AppInfoTourState();
}

class _AppInfoTourState extends State<AppInfoTour> {
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
    AppTourManager.showAppInfoTutorial(
      context: context,
      onFinish: () {
        // Save to your shared prefs
        // yourSharedPrefs.setPalmUploadTutorialSeen();

        context.goNamed(MobileAppRoutes.userDashBoardScreen.name, extra: true);
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
    return AppLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: context.translator.appInfo),
          32.h.verticalSpace,
          Column(
            key: AppTourKeys.appInfo,
            children: [
              _section(
                title: context.translator.privacyPolicy,
                onTap: () {
                  context.pushNamed(MobileAppRoutes.privacyPolicyScreen.name);
                },
              ),
              buildDivider(),
              _section(
                title: context.translator.spiritualDisclaimers,
                onTap: () {
                  context.pushNamed(
                    MobileAppRoutes.spiritualDisclaimerScreen.name,
                  );
                },
              ),
              buildDivider(),
              _section(
                title: context.translator.faqS,
                onTap: () {
                  context.pushNamed(MobileAppRoutes.faqScreen.name);
                },
              ),
              buildDivider(),
              _section(
                title: context.translator.termsAndConditions,
                onTap: () {
                  context.pushNamed(
                    MobileAppRoutes.termsAndConditionScreen.name,
                  );
                },
              ),
            ],
          ),
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
      title: AppText(text: title, style: medium(fontSize: 18)),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18.sp,
        color: AppColors.white,
      ),
    );
  }
}
