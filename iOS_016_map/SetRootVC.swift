//
//  SetRootVC.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 15/03/24.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(status: Bool){
        
        var rootVC : UIViewController?

        if(status == false){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoogleSignViewController") as! GoogleSignViewController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootNavigationVC")
        }
        
        let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
        window?.rootViewController = rootVC
    }
    
}
