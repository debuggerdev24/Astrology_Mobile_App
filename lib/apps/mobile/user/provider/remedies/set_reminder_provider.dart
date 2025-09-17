import 'package:astrology_app/apps/mobile/user/services/Remedies/remedy_api_service.dart';
import 'package:astrology_app/core/utils/field_validator.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/custom_toast.dart';
import '../../services/settings/aw_notification_service.dart';

class SetReminderProvider extends ChangeNotifier {
  int _selectedFrequency = 0;
  String _selectedWeekDays = "";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TextEditingController textReminderTitle = TextEditingController();
  TextEditingController textDate = TextEditingController();
  TextEditingController textTime = TextEditingController();

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  int get selectedFrequency => _selectedFrequency;
  String? get selectedWeekDays => _selectedWeekDays;
  String titleError = "", dateError = "", timeError = "";

  String get formattedDate => _selectedDate != null
      ? DateFormat("dd MMM yyyy").format(_selectedDate!)
      : "";

  void updateFrequency(int value) {
    _selectedFrequency = value;
    titleError = "";
    dateError = "";
    timeError = "";

    // Clear week days if not custom
    if (value != 4) {
      _selectedWeekDays = "";
    }

    notifyListeners();
  }

  void selectSingleWeekDay(String day) {
    _selectedWeekDays = day;
    notifyListeners();
  }

  //todo -------------> Date Picker
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      barrierColor: AppColors.black.withValues(alpha: 0.5),
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.whiteColor,
              onPrimary: AppColors.black,
              outline: AppColors.whiteColor,
              surface: AppColors.bgColor,
              onSurface: AppColors.whiteColor,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    textDate.text = DateFormat("dd MMM yyyy").format(_selectedDate!);
    notifyListeners();
  }

  //todo -------------> Time Picker
  Future<void> pickTime({
    required BuildContext context,
    bool? isFromEdit,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        Duration initialTimer = Duration(
          hours: _selectedTime?.hour ?? TimeOfDay.now().hour,
          minutes: _selectedTime?.minute ?? TimeOfDay.now().minute,
          seconds: 0,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Done button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ),
            CupertinoTheme(
              data: CupertinoThemeData(
                primaryColor: AppColors.redColor,
                brightness: Brightness.dark,
              ),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: initialTimer,
                onTimerDurationChanged: (Duration newTime) {
                  final hours = newTime.inHours;
                  final minutes = newTime.inMinutes % 60;

                  _selectedTime = TimeOfDay(hour: hours, minute: minutes);
                  final time =
                      "${hours.toString().padLeft(2, '0')}:"
                      "${minutes.toString().padLeft(2, '0')}";
                  textTime.text = time;
                },
              ),
            ),
            20.h.verticalSpace,
          ],
        );
      },
    );
  }

  //todo -------------> Create Reminder
  bool isCreateReminderLoading = false;
  Future<void> createReminder({
    required String remedyId,
    required BuildContext context,
    bool? checkDate,
  }) async {
    if (validate(context: context, checkDate: checkDate ?? false)) return;

    isCreateReminderLoading = true;
    notifyListeners();

    Map data = {
      "reminder_name": textReminderTitle.text.trim(),
      "reminder_type": selectedFrequency == 1
          ? "Daily"
          : selectedFrequency == 2
          ? "Weekly"
          : selectedFrequency == 3
          ? "Monthly"
          : "Custom",
      "remedy_id": remedyId,
      "time": textTime.text.trim(),
    };

    if (selectedFrequency == 2) {
      Logger.printInfo(_selectedWeekDays);
      data.addAll({
        "weekdays": [_selectedWeekDays],
      });
    } else if (selectedFrequency == 3) {
      data.addAll({"monthly_date": _selectedDate!.day});
    } else if (selectedFrequency == 4) {
      data.addAll({
        "start_date":
            "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}",
      });
    }
    final result = await RemedyApiService.instance.createReminder(data: data);
    result.fold(
      (l) {
        Logger.printError(l.toString());
      },
      (r) async {
        await scheduleReminderNotification(context: context);
        textTime.clear();
        textDate.clear();
        textReminderTitle.clear();
        _selectedFrequency = 0;
        _selectedWeekDays = "";
      },
    );
    isCreateReminderLoading = false;
    notifyListeners();
  }

  Future<void> scheduleReminderNotification({
    required BuildContext context,
  }) async {
    if (!_isInitialized || _selectedTime == null) return;

    final now = DateTime.now();
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    try {
      // ✅ Daily Notification
      if (_selectedFrequency == 1) {
        await AwNotificationService.scheduleDailyNotification(
          id: notificationId,
          title: "Reminder",
          body: "${textReminderTitle.text.trim()} (Daily)",
          time: _selectedTime!,
        );
        AppToast.success(context: context, message: "Daily Reminder Created");
      }
      // ✅ Weekly Notification
      else if (_selectedFrequency == 2) {
        final selectedDay = _selectedWeekDays;
        if (selectedDay.isNotEmpty) {
          final weekdays = {
            'Monday': 1,
            'Tuesday': 2,
            'Wednesday': 3,
            'Thursday': 4,
            'Friday': 5,
            'Saturday': 6,
            'Sunday': 7,
          };
          final targetWeekday = weekdays[selectedDay]!;

          // Create a DateTime for the notification
          DateTime targetDate = DateTime(
            now.year,
            now.month,
            now.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );

          // Find next occurrence of the target weekday
          while (targetDate.weekday != targetWeekday ||
              targetDate.isBefore(now)) {
            targetDate = targetDate.add(const Duration(days: 1));
          }

          await AwNotificationService.scheduleWeeklyNotification(
            id: notificationId,
            title: "Reminder",
            body: "${textReminderTitle.text.trim()} (Weekly - $selectedDay)",
            dateTime: targetDate,
            weekday: targetWeekday,
          );
          AppToast.success(
            context: context,
            message: "Weekly Reminder Created for $selectedDay",
          );
        }
      }
      // ✅ Monthly Notification
      else if (_selectedFrequency == 3 && _selectedDate != null) {
        DateTime targetDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        await AwNotificationService.scheduleMonthlyNotification(
          id: notificationId,
          title: "Reminder",
          body: "${textReminderTitle.text.trim()} (Monthly)",
          dateTime: targetDate,
          day: _selectedDate!.day,
        );
        AppToast.success(context: context, message: "Monthly Reminder Created");
      }
      // ✅ Custom (One-time) Notification
      else if (_selectedFrequency == 4 && _selectedDate != null) {
        final customDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        await AwNotificationService.scheduleCustomNotification(
          id: notificationId,
          title: "Reminder",
          body: "${textReminderTitle.text.trim()} (Custom)",
          dateTime: customDateTime,
          repeats: false, // One-time notification
        );
        AppToast.success(context: context, message: "Custom Reminder Created");
      }
    } catch (e) {
      Logger.printError("Awesome Notification scheduling error: $e");
      AppToast.error(
        context: context,
        message: "Failed to schedule notification: $e",
      );
    }
  }

  bool validate({required BuildContext context, required bool checkDate}) {
    titleError =
        FieldValidators().required(
          context,
          textReminderTitle.text.trim(),
          "Title",
        ) ??
        "";

    if (checkDate) {
      dateError =
          FieldValidators().required(context, textDate.text.trim(), "Date") ??
          "";
    }

    timeError =
        FieldValidators().required(context, textTime.text.trim(), "Time") ?? "";

    notifyListeners();
    if (timeError.isNotEmpty || dateError.isNotEmpty || titleError.isNotEmpty) {
      return true;
    }
    return false;
  }

  //todo ------------------------> Awesome Notifications initialize function
  bool _isInitialized = false;
  Future<void> initializeNotifications({required BuildContext context}) async {
    try {
      await AwNotificationService.initialize();

      // Request permission
      bool isAllowed = await AwNotificationService.isNotificationAllowed();
      if (!isAllowed) {
        bool permissionGranted =
            await AwNotificationService.requestPermission();
        if (!permissionGranted) {
          AppToast.error(
            context: context,
            message: "Notification permission denied",
          );
          return;
        }
      }

      _isInitialized = true;
      // AppToast.success(
      //   context: context,
      //   message: "Notifications initialized successfully",
      // );
    } catch (e) {
      Logger.printError("Awesome Notification initialization error: $e");
      AppToast.error(
        context: context,
        message: "Failed to initialize notifications: $e",
      );
    }
  }

  // Additional helper methods for Awesome Notifications

  /// Cancel a specific reminder by ID
  Future<void> cancelReminder(int notificationId, BuildContext context) async {
    try {
      await AwNotificationService.cancelNotification(notificationId);
      AppToast.success(context: context, message: "Reminder cancelled");
    } catch (e) {
      Logger.printError("Failed to cancel notification: $e");
      AppToast.error(context: context, message: "Failed to cancel reminder");
    }
  }

  /// Cancel all reminders
  Future<void> cancelAllReminders(BuildContext context) async {
    try {
      await AwNotificationService.cancelAllNotifications();
      AppToast.success(context: context, message: "All reminders cancelled");
    } catch (e) {
      Logger.printError("Failed to cancel all notifications: $e");
      AppToast.error(
        context: context,
        message: "Failed to cancel all reminders",
      );
    }
  }

  /// Get list of scheduled reminders
  Future<List<dynamic>> getScheduledReminders() async {
    try {
      return await AwNotificationService.getScheduledNotifications();
    } catch (e) {
      Logger.printError("Failed to get scheduled notifications: $e");
      return [];
    }
  }

  /// Clear all form data
  void clearForm() {
    textReminderTitle.clear();
    textDate.clear();
    textTime.clear();
    _selectedDate = null;
    _selectedTime = null;
    _selectedFrequency = 1;
    _selectedWeekDays = "";
    titleError = "";
    dateError = "";
    timeError = "";
    notifyListeners();
  }

  @override
  void dispose() {
    textReminderTitle.dispose();
    textDate.dispose();
    textTime.dispose();
    super.dispose();
  }
}

// import 'package:astrology_app/apps/mobile/user/services/Remedies/remedy_api_service.dart';
// import 'package:astrology_app/core/utils/field_validator.dart';
// import 'package:astrology_app/core/utils/logger.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/utils/custom_toast.dart';
// import '../../services/settings/notification_service.dart';
//
// class SetReminderProvider extends ChangeNotifier {
//   int _selectedFrequency = 1;
//   String _selectedWeekDays = "";
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   TextEditingController textReminderTitle = TextEditingController();
//   TextEditingController textDate = TextEditingController();
//   TextEditingController textTime = TextEditingController();
//
//   DateTime? get selectedDate => _selectedDate;
//   TimeOfDay? get selectedTime => _selectedTime;
//
//   int get selectedFrequency => _selectedFrequency;
//   String? get selectedWeekDays => _selectedWeekDays;
//   String titleError = "", dateError = "", timeError = "";
//
//   String get formattedDate => _selectedDate != null
//       ? DateFormat("dd MMM yyyy").format(_selectedDate!)
//       : "";
//
//   void updateFrequency(int value) {
//     _selectedFrequency = value;
//     titleError = "";
//     dateError = "";
//     timeError = "";
//
//     // Clear week days if not custom
//     if (value != 4) {
//       _selectedWeekDays = "";
//     }
//
//     notifyListeners();
//   }
//
//   void selectSingleWeekDay(String day) {
//     _selectedWeekDays = day;
//     notifyListeners();
//   }
//
//   //todo -------------> Date Picker
//   Future<void> pickDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       barrierColor: AppColors.black.withValues(alpha: 0.5),
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.dark().copyWith(
//             colorScheme: ColorScheme.dark(
//               primary: AppColors.whiteColor,
//               // Purple for selected date
//               onPrimary: AppColors.black,
//               outline: AppColors.whiteColor,
//               surface: AppColors.bgColor,
//               // Dark background
//               onSurface: AppColors.whiteColor,
//               brightness: Brightness.light,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate == null) return;
//
//     // combine Date + Time
//     _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
//
//     notifyListeners();
//   }
//
//   //todo -------------> Time Picker
//   Future<void> pickTime({
//     required BuildContext context,
//     bool? isFromEdit,
//   }) async {
//     showModalBottomSheet(
//       context: context,
//       showDragHandle: true,
//       backgroundColor: AppColors.bgColor,
//
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         Duration initialTimer = Duration(
//           hours: _selectedTime?.hour ?? TimeOfDay.now().hour,
//           minutes: _selectedTime?.minute ?? TimeOfDay.now().minute,
//           seconds: 0,
//         );
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Done button
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   context.pop();
//                 },
//                 child: Text(
//                   "Done",
//                   style: TextStyle(color: AppColors.whiteColor),
//                 ),
//               ),
//             ),
//             CupertinoTheme(
//               data: CupertinoThemeData(
//                 primaryColor: AppColors.redColor,
//                 brightness: Brightness.dark,
//               ),
//
//               child: CupertinoTimerPicker(
//                 mode: CupertinoTimerPickerMode.hms,
//                 initialTimerDuration: initialTimer,
//                 onTimerDurationChanged: (Duration newTime) {
//                   final hours = newTime.inHours;
//                   final minutes = newTime.inMinutes % 60;
//                   // final seconds = newTime.inSeconds % 60;
//
//                   _selectedTime = TimeOfDay(hour: hours, minute: minutes);
//                   final time =
//                       "${hours.toString().padLeft(2, '0')}:"
//                       "${minutes.toString().padLeft(2, '0')}";
//                   textTime.text = time;
//                 },
//               ),
//             ),
//             20.h.verticalSpace,
//           ],
//         );
//       },
//     );
//   }
//
//   //todo -------------> Create Reminder
//   bool isCreateReminderLoading = false;
//   Future<void> createReminder({
//     required String remedyId,
//     required BuildContext context,
//     bool? checkDate,
//   }) async {
//     if (validate(context: context, checkDate: checkDate ?? false)) return;
//
//     isCreateReminderLoading = true;
//     notifyListeners();
//
//     Map data = {
//       "reminder_name": textReminderTitle.text.trim(),
//       "reminder_type": selectedFrequency == 1
//           ? "Daily"
//           : selectedFrequency == 2
//           ? "Weekly"
//           : selectedFrequency == 3
//           ? "Monthly"
//           : "Custom",
//       "remedy_id": remedyId,
//       "time": textTime.text.trim(),
//     };
//     if (selectedFrequency == 2) {
//       data.addAll({
//         "weekdays": ["Saturday", "Sunday"],
//       });
//     } else if (selectedFrequency == 3) {
//       data.addAll({"monthly_date": 15});
//     } else if (selectedFrequency == 4) {
//       data.addAll({"start_date": "2025-10-12"});
//     }
//     final result = await RemedyApiService.instance.createReminder(data: data);
//     result.fold(
//       (l) {
//         Logger.printError(l.toString());
//       },
//       (r) async {
//         await scheduleReminderNotification(context: context);
//
//         textTime.clear();
//         textDate.clear();
//         textReminderTitle.clear();
//       },
//     );
//
//     isCreateReminderLoading = false;
//     notifyListeners();
//   }
//
//   Future<void> scheduleReminderNotification({
//     required BuildContext context,
//   }) async {
//     if (!_isInitialized || _selectedTime == null) return;
//
//     final hour = _selectedTime!.hour;
//     final minute = _selectedTime!.minute;
//     final now = DateTime.now();
//
//     try {
//       if (_selectedFrequency == 1) {
//         await NotificationService.instance.scheduleDailyNotification(
//           id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//           title: "Reminder",
//           body: "${textReminderTitle.text.trim()} (Daily)",
//           hour: hour,
//           minute: minute,
//           payload: 'daily_reminder_data',
//         );
//         AppToast.success(context: context, message: "Daily Reminder Created");
//       }
//       // ✅ Weekly
//       else if (_selectedFrequency == 2) {
//         final selectedDay = _selectedWeekDays;
//         if (selectedDay.isNotEmpty) {
//           final weekdays = {
//             'Mon': DateTime.monday,
//             'Tue': DateTime.tuesday,
//             'Wed': DateTime.wednesday,
//             'Thu': DateTime.thursday,
//             'Fri': DateTime.friday,
//             'Sat': DateTime.saturday,
//             'Sun': DateTime.sunday,
//           };
//           final targetWeekday = weekdays[selectedDay]!;
//
//           DateTime targetDate = DateTime(
//             now.year,
//             now.month,
//             now.day,
//             hour,
//             minute,
//           );
//
//           while (targetDate.weekday != targetWeekday ||
//               targetDate.isBefore(now)) {
//             targetDate = targetDate.add(const Duration(days: 1));
//           }
//
//           await NotificationService.instance.scheduleWeeklyNotification(
//             id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//             title: "Reminder",
//             body: "${textReminderTitle.text.trim()} (Weekly)",
//             weekday: targetWeekday,
//             hour: hour,
//             minute: minute,
//             payload: 'weekly_reminder_data',
//           );
//           AppToast.success(
//             context: context,
//             message: "Weekly Reminder Created",
//           );
//         }
//       }
//       // ✅ Monthly (repeat every month on same date)
//       else if (_selectedFrequency == 3 && _selectedDate != null) {
//         await NotificationService.instance.scheduleMonthlyNotification(
//           id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//           title: "Reminder",
//           body: "${textReminderTitle.text.trim()} (Monthly)",
//           day: _selectedDate!.day,
//           hour: hour,
//           minute: minute,
//           payload: 'monthly_reminder_data',
//         );
//         AppToast.success(context: context, message: "Monthly Reminder Created");
//       }
//       // ✅ Custom (one-time only)
//       else if (_selectedFrequency == 4 && _selectedDate != null) {
//         final customDateTime = DateTime(
//           _selectedDate!.year,
//           _selectedDate!.month,
//           _selectedDate!.day,
//           hour,
//           minute,
//         );
//
//         await NotificationService.instance.scheduleCustomNotification(
//           id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//           title: "Reminder",
//           body: "${textReminderTitle.text.trim()} (Custom)",
//           delay: customDateTime.difference(now),
//           payload: 'custom_reminder_data',
//         );
//         AppToast.success(context: context, message: "Custom Reminder Created");
//       }
//     } catch (e) {
//       Logger.printError("Notification scheduling error: $e");
//     }
//   }
//
//   bool validate({required BuildContext context, required bool checkDate}) {
//     titleError =
//         FieldValidators().required(
//           context,
//           textReminderTitle.text.trim(),
//           "Title",
//         ) ??
//         "";
//
//     if (checkDate) {
//       dateError =
//           FieldValidators().required(context, textDate.text.trim(), "Date") ??
//           "";
//     }
//
//     timeError =
//         FieldValidators().required(context, textTime.text.trim(), "Time") ?? "";
//
//     notifyListeners();
//     if (timeError.isNotEmpty || dateError.isNotEmpty || titleError.isNotEmpty) {
//       return true;
//     }
//     return false;
//   }
//
//   //todo ------------------------> notification initialize function
//   bool _isInitialized = false;
//   Future<void> initializeNotifications({required BuildContext context}) async {
//     try {
//       await NotificationService.instance.init();
//       _isInitialized = true;
//       AppToast.success(
//         context: context,
//         message: "Notifications initialized successfully",
//       );
//     } catch (e) {
//       // Show error to user
//       AppToast.error(context: context, message: e.toString());
//     }
//   }
// }
