import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

//  1. add in this for notification
//     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
//       GeneratedPluginRegistrant.register(with: registry)
//     }

    GeneratedPluginRegistrant.register(with: self)

//  2. add in this for notification
//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self
//     }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
