import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:app_settings/app_settings.dart';
import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/notification_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/app_layout.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<NotificationProvider>().getAndroidVersion();
    // Future.microtask(
    //   () => context
    //       .read<NotificationProvider>()
    //       .checkSystemNotificationPermission(),
    // );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Detect app resume
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      Logger.printInfo("App is resumed");

      if (mounted) {
        context
            .read<NotificationProvider>()
            .checkSystemNotificationPermission();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    final localeProvider = context.read<LocaleProvider>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        indexTabUser.value = 0;
        return;
      },
      child: AppLayout(
        horizontalPadding: 0,
        body: Consumer<UserAuthProvider>(
          builder: (context, provider, child) => Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    40.h.verticalSpace,
                    topBar(
                      showBackButton: false,
                      context: context,
                      title: context.translator.settings,
                      actionIcon: languages(localeProvider),
                    ),
                    32.h.verticalSpace,
                    _section(
                      title: context.translator.profile,
                      onTap: () {
                        context.pushNamed(MobileAppRoutes.profileScreen.name);
                      },
                    ),
                    buildDivider(),
                    _section(
                      title: context.translator.appInfo,
                      onTap: () {
                        context.pushNamed(MobileAppRoutes.appInfoScreen.name);
                      },
                    ),
                    Consumer<NotificationProvider>(
                      builder: (context, provider, child) {
                        if (Platform.isIOS || provider.androidVersion <= 12) {
                          return Column(
                            children: [
                              buildDivider(),
                              _section(
                                title: context.translator.notification,
                                trailing: Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    inactiveTrackColor: AppColors.greyColor,
                                    value: provider.isNotificationOn,
                                    onChanged: (value) async {
                                      await AppSettings.openAppSettings(
                                        type: AppSettingsType.notification,
                                      );
                                    },
                                  ),
                                ),
                                onTap: () async {
                                  await AppSettings.openAppSettings(
                                    type: AppSettingsType.notification,
                                  );
                                },
                              ),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    buildDivider(),
                    _section(
                      title: context.translator.subscription,
                      onTap: () {
                        context.pushNamed(
                          MobileAppRoutes.premiumPlanScreen.name,
                        );
                      },
                    ),
                    buildDivider(),
                    _section(
                      title: translator.logOut,
                      titleColor: Colors.red,
                      onTap: () async {
                        showLogOutConfirmationDialog(translator: translator);
                      },
                    ),
                    buildDivider(),
                    _section(
                      title: translator.deleteAccount,
                      titleColor: Colors.red,
                      onTap: () async {
                        showDeleteConfirmationDialog(translator: translator);
                      },
                    ),
                  ],
                ),
              ),
              if (provider.isLogOutLoading || provider.isDeleteAccount)
                FullPageIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog({required AppLocalizations translator}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            title: AppText(
              text: translator.deleteConfirmation,
              style: regular(color: AppColors.black),
            ),
            actions: [
              myActionButtonTheme(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await Future.delayed(const Duration(milliseconds: 100));
                  await context.read<UserAuthProvider>().deleteAccount(context);
                },
                title: translator.yes,
              ),
              myActionButtonTheme(
                onPressed: () {
                  context.pop();
                },
                title: translator.cancel,
              ),
            ],
          ),
        );
      },
    );
  }

  void showLogOutConfirmationDialog({required AppLocalizations translator}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            title: AppText(
              text: translator.logOutConfirmation,
              style: regular(color: AppColors.black),
            ),
            actions: [
              myActionButtonTheme(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await context.read<UserAuthProvider>().logOutUser(context);
                },
                title: translator.yes,
              ),
              myActionButtonTheme(
                onPressed: () {
                  context.pop();
                },
                title: translator.cancel,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget myActionButtonTheme({
    required VoidCallback onPressed,
    required String title,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: AppText(
        text: title,
        style: regular(
          color: (title == "Yes") ? AppColors.red : AppColors.black,
          fontSize: 16.5,
        ),
      ),
    );
  }

  PopupMenuButton<String> languages(LocaleProvider localeProvider) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (lang) {
        if (lang == "English") {
          localeProvider.setLocale("en");
        } else if (lang == "Hindi") {
          localeProvider.setLocale("hi");
        } else if (lang == "Tamil") {
          localeProvider.setLocale("ta");
        }
        callInitAPIs(context: context);
      },
      itemBuilder: (ctx) => [
        popupMenuItem(
          title: "Hindi",
          ctx: ctx,
          langCode: "hi",
          localeProvider: localeProvider,
        ),
        popupMenuItem(
          title: "English",
          ctx: ctx,
          langCode: "en",
          localeProvider: localeProvider,
        ),
        popupMenuItem(
          title: "Tamil",
          ctx: ctx,
          langCode: "ta",
          localeProvider: localeProvider,
        ),
      ],
      child: SizedBox(
        height: 28.h,
        width: 22.w,
        child: SVGImage(path: AppAssets.languageIcon),
      ),
    );
  }

  PopupMenuItem<String> popupMenuItem({
    required LocaleProvider localeProvider,
    required BuildContext ctx,
    required String title,
    required String langCode,
  }) {
    return PopupMenuItem(
      value: title,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            activeColor: AppColors.bgColor,
            value: langCode,
            groupValue: localeProvider.localeCode,
            onChanged: (value) {
              Navigator.pop(ctx);

              localeProvider.setLocale(value!);
              callInitAPIs(context: context);
            },
          ),
          AppText(
            text: title,
            style: regular(fontSize: 16, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() =>
      Divider(color: AppColors.whiteColor.withValues(alpha: 0.6), height: 18.h);

  Widget _section({
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: AppText(
        text: title,
        style: medium(fontSize: 16, color: titleColor),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18.sp,
            color: titleColor ?? AppColors.white,
          ),
    );
  }
}

//PopupMenuButton(
//                     onSelected: (lang) {
//                       if (lang == "English") {
//                         settingController.changeLanguage("en");
//                         // translator.translate("en", save: true);
//                       } else {
//                         settingController.changeLanguage("es");
//                         // translator.translate("es", save: true);
//                       }
//                     },
//                     child: Text(
//                       // translator.currentLocale!.languageCode == "en"
//                       //     ? "English"
//                       //     : "Español",
//                       settingController.languageCode == "en"
//                           ? "English"
//                           : "Español",
//                       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                     ),
//                     itemBuilder: (ctx) => [
//                       PopupMenuItem(
//                         value: "English",
//                         child: Text(
//                           "English",
//                           style:
//                               Theme.of(context).textTheme.bodyLarge!.copyWith(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: "Spanish",
//                         child: Text(
//                           "Español",
//                           style:
//                               Theme.of(context).textTheme.bodyLarge!.copyWith(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
