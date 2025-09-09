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
import '../../services/settings/notification_service.dart';

class SetReminderProvider extends ChangeNotifier {
  String _selectedFrequency = 'Daily', _selectedWeekDays = "";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TextEditingController textReminderTitle = TextEditingController();
  TextEditingController textDate = TextEditingController();
  TextEditingController textTime = TextEditingController();

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  String get selectedFrequency => _selectedFrequency;
  String? get selectedWeekDays => _selectedWeekDays;
  String titleError = "", dateError = "", timeError = "";

  String get formattedDate => _selectedDate != null
      ? DateFormat("dd MMM yyyy").format(_selectedDate!)
      : "";

  void updateFrequency(String value) {
    _selectedFrequency = value;
    titleError = "";
    dateError = "";
    timeError = "";

    // Clear week days if not custom
    if (value != 'Custom' && value != 'custom') {
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
              // Purple for selected date
              onPrimary: AppColors.black,
              outline: AppColors.whiteColor,
              surface: AppColors.bgColor,
              // Dark background
              onSurface: AppColors.whiteColor,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // combine Date + Time
    _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

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
                  // final seconds = newTime.inSeconds % 60;

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
      "reminder_type": selectedFrequency,
      "remedy_id": remedyId,
      "time": textTime.text.trim(),
    };
    if (selectedFrequency == "Weekly") {
      data.addAll({
        "weekdays": ["Saturday", "Sunday"],
      });
    } else if (selectedFrequency == "Monthly") {
      data.addAll({"monthly_date": 15});
    } else if (selectedFrequency == "Custom") {
      data.addAll({"start_date": "2025-10-12"});
    }
    final result = await RemedyApiService.instance.createReminder(data: data);
    result.fold(
      (l) {
        Logger.printError(l.toString());
      },
      (r) async {
        AppToast.success(
          context: context,
          message: "Reminder Created Successfully.",
        );
        textTime.clear();
        textDate.clear();
        await scheduleReminderNotification(context: context);
        textReminderTitle.clear();
      },
    );

    isCreateReminderLoading = false;
    notifyListeners();
  }

  Future<void> scheduleReminderNotification({
    required BuildContext context,
  }) async {
    if (!_isInitialized || _selectedTime == null) return;

    final hour = _selectedTime!.hour;
    final minute = _selectedTime!.minute;
    final now = DateTime.now();

    try {
      if (_selectedFrequency == 'Daily') {
        await NotificationService.instance.scheduleDailyNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: "Reminder",
          body: "${textReminderTitle.text.trim()} (Daily)",
          hour: hour,
          minute: minute,
          payload: 'daily_reminder_data',
        );
        AppToast.success(context: context, message: "Reminder Created");
      }
      // ✅ Weekly
      else if (_selectedFrequency == 'Weekly') {
        final selectedDay = _selectedWeekDays;
        if (selectedDay.isNotEmpty) {
          final weekdays = {
            'Mon': DateTime.monday,
            'Tue': DateTime.tuesday,
            'Wed': DateTime.wednesday,
            'Thu': DateTime.thursday,
            'Fri': DateTime.friday,
            'Sat': DateTime.saturday,
            'Sun': DateTime.sunday,
          };
          final targetWeekday = weekdays[selectedDay]!;

          DateTime targetDate = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          while (targetDate.weekday != targetWeekday ||
              targetDate.isBefore(now)) {
            targetDate = targetDate.add(const Duration(days: 1));
          }

          await NotificationService.instance.scheduleWeeklyNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title: "Reminder",
            body: "${textReminderTitle.text.trim()} (Weekly)",
            weekday: targetWeekday,
            hour: hour,
            minute: minute,
            payload: 'weekly_reminder_data',
          );
        }
      }
      // ✅ Monthly (repeat every month on same date)
      else if (_selectedFrequency == 'Monthly' && _selectedDate != null) {
        await NotificationService.instance.scheduleMonthlyNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: "Reminder",
          body: "${textReminderTitle.text.trim()} (Monthly)",
          day: _selectedDate!.day,
          hour: hour,
          minute: minute,
          payload: 'monthly_reminder_data',
        );
      }
      // ✅ Custom (one-time only)
      else if (_selectedFrequency == 'Custom' && _selectedDate != null) {
        final customDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          hour,
          minute,
        );

        await NotificationService.instance.scheduleCustomNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: "Reminder",
          body: "${textReminderTitle.text.trim()} (Custom)",
          delay: customDateTime.difference(now),
          payload: 'custom_reminder_data',
        );
      }
    } catch (e) {
      Logger.printError("Notification scheduling error: $e");
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

  //todo ------------------------> notification initialize function
  bool _isInitialized = false;
  Future<void> initializeNotifications({required BuildContext context}) async {
    try {
      await NotificationService.instance.init();
      _isInitialized = true;
      AppToast.success(
        context: context,
        message: "Notifications initialized successfully",
      );
    } catch (e) {
      // Show error to user
      AppToast.error(context: context, message: e.toString());
    }
  }
}
