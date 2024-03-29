//
//  UserInfoFromGoogleViewController.swift
//  Pods
//
//  Created by DREAMWORLD on 15/03/24.
//

import UIKit

class UserInfoFromGoogleViewController: UIViewController {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var profileURl: URL!
    var name: String!
    var email: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2

        lblName.text = name
        lblEmail.text = email
        
        if let data = try? Data(contentsOf: profileURl) {
            profileImage.image = UIImage(data: data)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))
    }
    
    @objc func signOutTapped() {
        
    }

}
