import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezones
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
          "assets/icon/icon.png",
        ); //@mipmap/ic_launcher
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    //
    //   print('Android Version: ${androidInfo.version.release}'); // "13"
    //   print('SDK Int: ${androidInfo.version.sdkInt}'); // 33
    //   print('Security Patch: ${androidInfo.version.securityPatch}');
    //   print('Device Model: ${androidInfo.model}'); // "Pixel 7"
    //   print('Brand: ${androidInfo.brand}'); // "Google"
    //   print('Manufacturer: ${androidInfo.manufacturer}'); // "Google"
    // }
    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    // Initialize with callback for when notification is tapped
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.data}');
      },
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    }

    // Optional: open settings if permanently denied
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // Future<void> _requestPermissions() async {
  //   if (Platform.isAndroid) {
  //     // For Android 13+ (API level 33+)
  //
  //     await _notificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin
  //         >()
  //         ?.requestNotificationsPermission();
  //   } else {
  //     // For iOS
  //     await _notificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin
  //         >()
  //         ?.requestPermissions(alert: true, badge: true, sound: true);
  //   }
  // }

  //todo fo testing purpose
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'instant_channel', // channel ID
          'Instant Notifications', // channel name
          channelDescription: 'Channel for instant notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  //todo ---------------------> Custom
  Future<void> scheduleCustomNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(delay);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'scheduled_channel', // channel ID
          'Scheduled Notifications', // channel name
          channelDescription: 'Channel for scheduled notifications',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  //todo ---------------------> Daily Notification
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time has passed for today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'Channel for daily notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  //todo ---------------------> Weekly Notification
  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int weekday, // Monday = 1, Sunday = 7
    required int hour,
    required int minute,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_channel',
          'Weekly Notifications',
          channelDescription: 'Channel for weekly notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  //todo ---------------------> Monthly Notification
  Future<void> scheduleMonthlyNotification({
    required int id,
    required String title,
    required String body,
    required int day,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      hour,
      minute,
    );

    // If selected day already passed this month, schedule for next month
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month + 1,
        day,
        hour,
        minute,
      );
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'monthly_channel',
          'Monthly Notifications',
          channelDescription: 'Channel for monthly reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}
