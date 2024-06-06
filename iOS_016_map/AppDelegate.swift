//
//  AppDelegate.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 12/03/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import FacebookCore
import FBSDKCoreKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseAuth
import Messages
import FirebaseMessaging
import StripeCore
import FirebaseDynamicLinks
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    //let googleClientID = "403945920079-rrm8jmmm6shdis0ug460kuosp6b9tglf.apps.googleusercontent.com"
    let googleClientID = "631970002050-mrdm5bvq974jkps9rkqqoqcg71stklrc.apps.googleusercontent.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        //configureUserNotifications()
        Messaging.messaging().delegate = self
        registerForPushNotifications()
        IQKeyboardManager.shared.enable = true
        
        if let lang = UserDefaults.standard.object(forKey: "myLanguage") as? String {
            print(lang)
            if lang == "Default" {
                if let langTag = Locale.preferredLanguages.first?.components(separatedBy: "-").first {
                    if languagesTag.contains(langTag) {
                        USER_LANGUAGE = langTag
                    } else {
                        USER_LANGUAGE = "en"
                    }
                }
            } else {
                USER_LANGUAGE = lang
            }
        }
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyC8d0SF7qCwx8v7Wfi4egWTD0rRSqK8MNk")
        GMSPlacesClient.provideAPIKey("AIzaSyC8d0SF7qCwx8v7Wfi4egWTD0rRSqK8MNk")
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if error == nil || user != nil {
//                Switcher.updateRootVC(status: true)
//            } else {
//                if let token = AccessToken.current, !token.isExpired {
//                    Switcher.updateRootVC(status: true)
//                } else {
//                    if Auth.auth().currentUser != nil {
//                        Switcher.updateRootVC(status: true)
//                    } else {
//                        Switcher.updateRootVC(status: false)
//                    }
//                    
//                }
//            }
//        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        handled = GIDSignIn.sharedInstance.handle(url)
        
        if handled {
            return true
        }
    
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleDynamicLinks(with: dynamicLink)
            return true
        }
        
        return false
    }
    
    func registerForPushNotifications() {
            
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else {
                    DispatchQueue.main.async {
                        self.showPermissionAlert()
                    }
                    return
                }
                self.getNotificationSettings()
            }
        }
        else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            //            guard settings.soundSetting = DefaultIndices else {return}
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func showPermissionAlert() {
        let alertController = UIAlertController(title: "Notification", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            self.gotoAppSettings()
            alertController.dismiss(animated: false, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func gotoAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
    
    func handleDynamicLinks(with dymailLink: DynamicLink) {
        guard let url = dymailLink.url else {
            print("dynamic link has no url")
            return
        }

        print("URl Parameter is \(url.absoluteString)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("message receive")
        
        switch response.actionIdentifier {
        case "okAction":
            print("\(response.notification.request.content.userInfo)")
        case "cancelAction":
            print("cancel button tapped")
        default:
            break
        }
        
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfoContent = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfoContent)
        
        completionHandler([.sound, .badge, .alert])
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler (.newData)
        print(userInfo)
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token:  \(String(describing: fcmToken))")

//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        NotificationCenter.default.post(
//            name: Notification.Name("FCMToken"),
//            object: nil,
//            userInfo: dataDict
//        )
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        print("APNs device token1: \(tokenString(deviceToken))")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func tokenString(_ deviceToken:Data) -> String{
        //code to make a token string
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        return token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
        /*if UserDefaults.standard.object(forKey: KEY.pref_device_token) == nil
         {
         UserDefaults.standard.set("", forKey: KEY.pref_device_token)
         UserDefaults.standard.synchronize()
         }*/
    }
    
}
