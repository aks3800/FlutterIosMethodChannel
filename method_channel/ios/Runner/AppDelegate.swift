import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        requestPermission()
        GeneratedPluginRegistrant.register(with: self)
        UNUserNotificationCenter.current().delegate = self
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let badgeChannel = FlutterMethodChannel(name: "method_channel.flutter.dev/appIconBadge", binaryMessenger: controller.binaryMessenger)
        badgeChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            guard call.method == "getBadgeCount" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.receiveBadgeCount(result: result)
        })
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func receiveBadgeCount(result: FlutterResult) -> Void {
        result(UIApplication.shared.applicationIconBadgeNumber)
    }
    
    func requestPermission() -> Void {
        let notificationsCenter = UNUserNotificationCenter.current()
        notificationsCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("error while requesting permission: \(error.localizedDescription)")
            }
            if granted {
                print("permission granted")
            } else {
                print("permission denied")
            }
        }
    }
}
