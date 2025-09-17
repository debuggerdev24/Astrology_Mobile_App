import 'package:astrology_app/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../constants/app_colors.dart';
import '../widgets/app_text.dart';

class AppToast {
  // Base show method
  static void show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    Color? textColor,
    Icon? icon,
    ToastificationType type = ToastificationType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    toastification.show(
      primaryColor: AppColors.whiteColor,
      context: context,
      type: type,
      backgroundColor: backgroundColor,
      autoCloseDuration: duration,
      direction: TextDirection.ltr,
      icon: icon,
      title: AppText(
        text: message,
        style: medium(color: textColor ?? AppColors.whiteColor, fontSize: 15),
      ),
    );
  }
  //

  static void success({
    required BuildContext context,
    required String message,
  }) {
    show(
      context: context,
      message: message,
      type: ToastificationType.success,
      backgroundColor: Colors.green.shade600,
    );
  }

  static void error({required BuildContext context, required String message}) {
    show(
      context: context,
      message: message,
      type: ToastificationType.error,
      backgroundColor: Colors.red.shade600,
    );
  }

  static void warning({
    required BuildContext context,
    required String message,
  }) {
    show(
      context: context,
      message: message,
      textColor: AppColors.black,
      type: ToastificationType.warning,
      backgroundColor: Colors.yellow,
      icon: Icon(Icons.warning_amber_rounded, color: AppColors.black),
    );
  }

  static void info({required BuildContext context, required String message}) {
    show(
      context: context,
      message: message,
      type: ToastificationType.info,
      backgroundColor: Colors.blue,
    );
  }
}
