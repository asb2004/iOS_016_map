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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //let googleClientID = "403945920079-rrm8jmmm6shdis0ug460kuosp6b9tglf.apps.googleusercontent.com"
    let googleClientID = "734298926859-hjocmbr73l7fod8q2kt79c45e2e512k9.apps.googleusercontent.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        
        language = UserDefaults.standard.object(forKey: "myLanguage") as? String ?? "en"
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDbArELia4n5rp8Jqq1NanUrzyEAA0BIPw")
        GMSPlacesClient.provideAPIKey("AIzaSyDbArELia4n5rp8Jqq1NanUrzyEAA0BIPw")
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil || user != nil {
                Switcher.updateRootVC(status: true)
            } else {
                if let token = AccessToken.current, !token.isExpired {
                    Switcher.updateRootVC(status: true)
                } else {
                    if Auth.auth().currentUser != nil {
                        Switcher.updateRootVC(status: true)
                    } else {
                        Switcher.updateRootVC(status: false)
                    }
                    
                }
            }
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
        
        return false
    }
}

