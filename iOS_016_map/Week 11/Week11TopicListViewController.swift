//
//  Week11TopicListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 27/05/24.
//

import UIKit

class Week11TopicListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func localNotificationTapped(_ sender: UIButton) {
        let vc = week11Storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dynamicLinkButtonTapped(_ sender: UIButton) {
        let vc = week11Storyboard.instantiateViewController(withIdentifier: "ShareProductListViewController") as! ShareProductListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
