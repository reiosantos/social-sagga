import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let CHANNEL = "flutter.native/helper"
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) ->Void in
            guard call.method == "openWhatsApp" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.openWhatsApp(result: result)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func openWhatsApp(result: FlutterResult) {
        var str = "Hello to whatsapp"
        str = str.addingPercentEncoding(withAllowedCharacters: (NSCharacterSet.urlQueryAllowed))!
        let whatsappURL = NSURL(string: "whatsapp://send?text=\(str)")
        
        if UIApplication.shared.canOpenURL(whatsappURL! as URL) {
            UIApplication.shared.openURL(whatsappURL! as URL)
        } else {
            let ms = "Whatsapp is not installed on this device. Please install Whatsapp and try again."
            let alertController = UIAlertController(title: "Not Found", message: ms, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            alertController.present(alertController, animated: true, completion: nil)
        }
        return result("DUDE");
    }
}
