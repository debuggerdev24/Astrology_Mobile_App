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
  }) async {
    if (validate(context: context)) return;

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
    Logger.printInfo("djbafhewvjevwfvwfbwjkfweew");
    final result = await RemedyApiService.instance.createReminder(data: data);
    result.fold(
      (l) {
        Logger.printError(l.toString());
      },
      (r) {
        AppToast.success(
          context: context,
          message: "Reminder Created Successfully.",
        );
        textTime.clear();
        textReminderTitle.clear();
        textDate.clear();
      },
    );

    isCreateReminderLoading = false;
    notifyListeners();
  }

  bool validate({required BuildContext context}) {
    titleError =
        FieldValidators().required(
          context,
          textReminderTitle.text.trim(),
          "Title",
        ) ??
        "";

    dateError =
        FieldValidators().required(context, textDate.text.trim(), "Date") ?? "";

    timeError =
        FieldValidators().required(context, textTime.text.trim(), "Time") ?? "";

    notifyListeners();
    if (timeError.isNotEmpty || dateError.isNotEmpty || titleError.isNotEmpty) {
      return true;
    }

    return false;
  }
}
