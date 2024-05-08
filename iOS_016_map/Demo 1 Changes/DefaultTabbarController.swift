//
//  DefaultTabbarController.swift
//  CustomTabBar
//
//  Created by DREAMWORLD on 13/03/24.
//

import UIKit

class DefaultTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

}
