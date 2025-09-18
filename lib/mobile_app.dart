import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/home/home_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/remedies/set_reminder_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/app_info_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/notification_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/profile_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/routes/mobile_routes/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_theme.dart';
import 'l10n/app_localizations.dart';

class AstrologyMobileApp extends StatelessWidget {
  const AstrologyMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: const Size(375, 812),
        builder: (context, child) {
          final provider = context.watch<LocaleProvider>();
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => SetReminderProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserProfileProvider(),
              ),

              ChangeNotifierProvider(
                create: (context) => SubscriptionProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => NotificationProvider(),
              ),

              ChangeNotifierProvider(create: (context) => UserAuthProvider()),
              ChangeNotifierProvider(create: (context) => PalmProvider()),
              ChangeNotifierProvider(create: (context) => HomeProvider()),
              ChangeNotifierProvider(create: (context) => MantraProvider()),
              ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
              ChangeNotifierProvider(create: (_) => AppInfoProvider()),
            ],
            child: MaterialApp.router(
              theme: AppTheme.appThemeData,
              locale: Locale(provider.localeCode),
              supportedLocales: const [
                Locale("en"),
                Locale("hi"),
                Locale("ta"),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              routerConfig: MobileAppRouter.goRouter,
            ),
          );
        },
      ),
    );
  }
}
