import 'package:astrology_app/apps/mobile/user/provider/auth/auth_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/notification_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/app_layout.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        indexTabUser.value = 0;
        return;
      },
      child: AppLayout(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.h.verticalSpace,
            topBar(
              showBackButton: false,
              context: context,
              title: context.translator.settings,
              actionIcon: PopupMenuButton<String>(
                onSelected: (lang) {
                  if (lang == "English") {
                    localeProvider.setLocale("en");
                  } else if (lang == "Hindi") {
                    localeProvider.setLocale("hi");
                  } else if (lang == "Tamil") {
                    localeProvider.setLocale("ta");
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: "English",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          activeColor: AppColors.bgColor,
                          value: "en",
                          groupValue: localeProvider.localeCode,
                          onChanged: (value) {},
                        ),
                        AppText(
                          text: "Eng",
                          style: regular(fontSize: 16, color: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "Hindi",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          activeColor: AppColors.bgColor,
                          value: "hi",
                          groupValue: localeProvider.localeCode,
                          onChanged: (value) {},
                        ),
                        AppText(
                          text: "हिंदी",
                          style: regular(fontSize: 16, color: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "Tamil",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          activeColor: AppColors.bgColor,
                          value: "ta",
                          groupValue: localeProvider.localeCode,
                          onChanged: (value) {},
                        ),
                        AppText(
                          text: "தமிழ்",
                          style: regular(fontSize: 16, color: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                ],
                child: SizedBox(
                  height: 28.h,
                  width: 22.w,
                  child: SVGImage(path: AppAssets.languageIcon),
                ),
              ),
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
            buildDivider(),
            Consumer<NotificationProvider>(
              builder: (context, provider, child) => _section(
                title: context.translator.notification,
                trailing: CupertinoSwitch(
                  inactiveTrackColor: AppColors.greyColor,
                  value: provider.isNotificationOn,
                  onChanged: (value) {
                    provider.isNotificationOn = value;
                  },
                ),
                onTap: () {
                  provider.isNotificationOn = !provider.isNotificationOn;
                },
              ),
            ),
            buildDivider(),
            _section(
              title: context.translator.premium,
              onTap: () {
                context.pushNamed(MobileAppRoutes.premiumPlanScreen.name);
              },
            ),
            buildDivider(),
            _section(
              title: "Log Out",
              titleColor: Colors.red,
              onTap: () async {
                await context.read<UserAuthProvider>().logOutUser(context);
                // context_extension.pushNamed(MobileAppRoutes.premiumPlanScreen.name);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Divider(color: AppColors.whiteColor.withValues(alpha: 0.6)),
  );

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
        style: medium(fontSize: 18.sp, color: titleColor),
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
