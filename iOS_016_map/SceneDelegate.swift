//
//  SceneDelegate.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 12/03/24.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        
        
        if Auth.auth().currentUser != nil {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "rootNavigationVC")
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            
            if let userActivity = connectionOptions.userActivities.first(where: { $0.activityType == NSUserActivityTypeBrowsingWeb }) {
                if let incomingURL = userActivity.webpageURL {
                    self.handleIncomingURL(with: incomingURL)
                    return
                }
            }
        } else if let token = AccessToken.current, !token.isExpired {
            print("facebook")
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "rootNavigationVC")
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            
            if let userActivity = connectionOptions.userActivities.first(where: { $0.activityType == NSUserActivityTypeBrowsingWeb }) {
                if let incomingURL = userActivity.webpageURL {
                    self.handleIncomingURL(with: incomingURL)
                    return
                }
            }
        } else {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "GoogleSignViewController") as! GoogleSignViewController
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        changeOnlineStatus(with: false)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        changeOnlineStatus(with: true)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        changeOnlineStatus(with: false)
    }
    
    func changeOnlineStatus(with status: Bool) {
        if Auth.auth().currentUser != nil {
            if let userID = Auth.auth().currentUser?.uid {
                let db = Firestore.firestore()
                db.collection("users").document(userID).updateData(["isOnline": status])
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            print("incoming URL is \(incomingURL)")
            self.handleIncomingURL(with: incomingURL)
        }
    }
    
    func handleIncomingURL(with url: URL) {
        
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let dynamicLink = dynamicLink {
                self.handleDynamicLinks(with: dynamicLink)
            }
        }
        
    }
    
    func handleDynamicLinks(with dymailLink: DynamicLink) {
        guard let url = dymailLink.url else {
            print("dynamic link has no url")
            return
        }
        
        print("URl Parameter is \(url.absoluteString)")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return }
//        }
        
        if components.path == "/product" {
            if let productQueryItem = queryItems.first(where: { $0.name == "pid" }) {
                let pid = productQueryItem.value
                
                if Auth.auth().currentUser != nil {
                    if let pid = pid {
                        self.openShareProductView(with: pid)
                    }
                    
                } else if let token = AccessToken.current, !token.isExpired {
                    print("facebook")
                    if let pid = pid {
                        self.openShareProductView(with: pid)
                    }
                } else {
                    let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "GoogleSignViewController") as! GoogleSignViewController
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    func openShareProductView(with pid: String) {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "rootNavigationVC") as! UINavigationController
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        let prdVC = week11Storyboard.instantiateViewController(withIdentifier: "ShareProductListViewController") as! ShareProductListViewController
        prdVC.initialPid = pid
        vc.pushViewController(prdVC, animated: true)

    }

}

