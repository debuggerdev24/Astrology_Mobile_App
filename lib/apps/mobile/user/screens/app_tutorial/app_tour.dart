import 'dart:ui';

import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text.dart';

//todo Central manager for all app tours/tutorials
class AppTourManager {
  static TutorialCoachMark? _currentTutorial;

  /// Show Mantra Screen Tutorial
  static void showMantraTutorial({
    required BuildContext context,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    _currentTutorial = _createTutorial(
      targets: AppTourTargets.mantraScreenTargets(context: context),
      onFinish: onFinish,
      onSkip: onSkip,
    );
    _currentTutorial!.show(context: context);
  }

  /// Show Palm Upload Tutorial
  static void showPalmUploadTutorial({
    required BuildContext context,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    _currentTutorial = _createTutorial(
      targets: AppTourTargets.palmUploadTargets(context: context),
      onFinish: onFinish,
      onSkip: onSkip,
    );
    _currentTutorial!.show(context: context);
  }

  /// Show Palm Reading Tutorial
  static void showPalmReadingTutorial({
    required BuildContext context,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    _currentTutorial = _createTutorial(
      targets: AppTourTargets.palmReadingTargets(context: context),
      onFinish: onFinish,
      onSkip: onSkip,
    );
    _currentTutorial!.show(context: context);
  }

  //Show Remedy Tutorial
  static void showRemedyTutorial({
    required BuildContext context,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    _currentTutorial = _createTutorial(
      targets: AppTourTargets.remediesTargets(context: context),
      onFinish: onFinish,
      onSkip: onSkip,
    );
    _currentTutorial!.show(context: context);
  }

  //Show Profile Tutorial
  static void showProfileTutorial({
    required BuildContext context,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    _currentTutorial = _createTutorial(
      targets: AppTourTargets.profileTargets(context: context),
      onFinish: onFinish,
      onSkip: onSkip,
    );
    _currentTutorial!.show(context: context);
  }

  //Show App info Tutorial
  static void showAppInfoTutorial({
    required BuildContext context,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    _currentTutorial = _createTutorial(
      targets: AppTourTargets.appInfoTargets(context: context),
      onFinish: onFinish,
      onSkip: onSkip,
    );
    _currentTutorial!.show(context: context);
  }

  /// Create tutorial with common configuration
  static TutorialCoachMark _createTutorial({
    required List<TargetFocus> targets,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: onFinish,
      onSkip: () {
        onSkip?.call();
        return true;
      },
      onClickTarget: (target) {
        // Handle target click if needed
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        // Handle tap position if needed
      },
      onClickOverlay: (target) {
        // Handle overlay click if needed
      },
    );
  }

  /// Finish current tutorial
  static void finishTutorial() {
    _currentTutorial?.finish();
    _currentTutorial = null;
  }

  /// Skip current tutorial
  static void skipTutorial() {
    _currentTutorial?.skip();
    _currentTutorial = null;
  }
}

//todo All tutorial targets configuration
class AppTourTargets {
  // Mantra Screen Targets
  static List<TargetFocus> mantraScreenTargets({
    required BuildContext context,
  }) => [
    _createTargetFocus(
      key: AppTourKeys.mantraPlayerCardKey,
      contents: [
        _createTargetContent(
          align: ContentAlign.bottom,
          text: context.translator.mantraSectionTutorial,
          //"Listen to daily mantras and keep your mind calm. Tap on a mantra’s text or audio icon to open the full audio screen.",
        ),
      ],
    ),
  ];

  /// Palm Upload Screen Targets
  static List<TargetFocus> palmUploadTargets({required BuildContext context}) =>
      [
        _createTargetFocus(
          key: AppTourKeys.palmSectionsKey,
          contents: [
            _createTargetContent(
              align: ContentAlign.bottom,
              text: context.translator.palmSectionTutorial,
            ),
          ],
        ),
      ];

  /// Palm Reading Screen Targets
  static List<TargetFocus> palmReadingTargets({
    required BuildContext context,
  }) => [
    _createTargetFocus(
      key: AppTourKeys.premiumDialogKey,
      shape: ShapeLightFocus.RRect,
      radius: 12,
      contents: [
        _createTargetContent(
          align: ContentAlign.bottom,
          text: context.translator.premiumDialogTutorial,
        ),
      ],
    ),
  ];

  /// Remedies Screen Targets
  static List<TargetFocus> remediesTargets({required BuildContext context}) => [
    _createTargetFocus(
      key: AppTourKeys.remediesKey,
      contents: [
        _createTargetContent(
          align: ContentAlign.bottom,
          text: context.translator.remedySectionTutorial,
        ),
      ],
    ),
  ];

  /// Profile Targets
  static List<TargetFocus> profileTargets({required BuildContext context}) => [
    _createTargetFocus(
      key: AppTourKeys.profileKey,
      contents: [
        _createTargetContent(
          align: ContentAlign.bottom,
          text: context.translator.profileSectionTutorial,
        ),
      ],
    ),
  ];

  /// Profile Targets
  static List<TargetFocus> appInfoTargets({required BuildContext context}) => [
    _createTargetFocus(
      key: AppTourKeys.appInfo,
      contents: [
        _createTargetContent(
          align: ContentAlign.bottom,
          text: context.translator.appInfoSectionTutorial,
        ),
      ],
    ),
  ];

  // ==================== PRIVATE HELPER METHODS ====================

  static TargetFocus _createTargetFocus({
    required GlobalKey key,
    required List<TargetContent> contents,
    bool enableTargetTab = true,
    ShapeLightFocus shape = ShapeLightFocus.RRect,
    double radius = 8,
  }) {
    return TargetFocus(
      keyTarget: key,
      enableTargetTab: enableTargetTab,
      enableOverlayTab: true,
      shape: shape,
      radius: radius,
      borderSide: const BorderSide(
        color: Color(0xFFFF9800), // Orange color
        width: 2,
      ),
      contents: contents,
    );
  }

  static TargetContent _createTargetContent({
    required String text,
    required ContentAlign align,
  }) {
    return TargetContent(
      align: align,
      builder: (context, controller) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 320),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: AppColors.whiteColor,
              radius: Radius.circular(12.r),
              dashPattern: [4, 3],
              strokeWidth: 1.5,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            child: Column(
              spacing: 12.h,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: text, style: regular(fontSize: 18, height: 1.3)),
                Row(
                  spacing: 8.w,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   onPressed: () => controller.previous(),
                    //   child: AppText(
                    //     text: 'Previous',
                    //     style: regular(fontSize: 14, color: Colors.white70),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () => controller.next(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),

                      child: AppText(
                        text: context.translator.next,
                        style: regular(fontSize: 14, color: AppColors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AppTourKeys {
  // Mantra Screen Keys
  static final mantraPlayerCardKey = GlobalKey(debugLabel: 'mantraPlayerCard');

  // Palm Upload Screen Keys
  static final palmSectionsKey = GlobalKey(debugLabel: 'palmSections');
  static final rightPalmUploadKey = GlobalKey(debugLabel: 'rightPalmUpload');
  static final palmInstructionsKey = GlobalKey(debugLabel: 'palmInstructions');
  static final submitPalmButtonKey = GlobalKey(debugLabel: 'submitPalmButton');

  // Palm Reading
  static final premiumDialogKey = GlobalKey(debugLabel: 'premiumDialog');

  // Remedy
  static final remediesKey = GlobalKey(debugLabel: 'remedies');

  //Profile
  static final profileKey = GlobalKey(debugLabel: 'profile');

  //App Info
  static final appInfo = GlobalKey(debugLabel: 'appInfo');
}
