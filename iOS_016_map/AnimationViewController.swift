//
//  AnimationViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 21/03/24.
//

import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet weak var signInTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var drawerImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sideConentView: UIView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var animateButton: UIButton!
    
    var animataion = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "drawer_icon"), style: .plain, target: self, action: #selector(customSideBarTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.signInLabel.alpha = 0.0
        self.signInLabel.transform = CGAffineTransform(translationX: 0, y: -200)
        self.emailText.transform = CGAffineTransform(translationX: -400, y: 0)
        self.passwordLabel.transform = CGAffineTransform(translationX: 400, y: 0)
        self.animateButton.transform = CGAffineTransform(translationX: 0, y: 200)
        self.animateButton.frame.size.height = 0
        
        UIView.animate(withDuration: 2.0) {
            self.signInLabel.alpha = 1.0
            self.signInLabel.transform = .identity
            self.emailText.transform = .identity
            self.passwordLabel.transform = .identity
            self.animateButton.transform = .identity
            self.animateButton.frame.size.height = 40
        }
    }
    
    @objc func customSideBarTapped() {
        //sideView.isHidden = false
//        sideView.frame.size.width = 0
//        sideConentView.frame.size.width = 0
//
//        imageView.frame.size.width = 0
//        UIView.animate(withDuration: 1.0) {
//            self.sideView.frame.size.width = 300
//            self.sideConentView.frame.size.width = 300
//        }
    }

    @IBAction func animateButtonTapped(_ sender: Any) {
        
//        if animataion < 7 {
//            UIView.animate(withDuration: 1.0, delay: 0.1, options: [], animations: {
//                switch self.animataion {
//                case 1:
//                    self.drawerImage.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//                    self.animataion += 1
//
//                case 2:
//                    self.drawerImage.transform = CGAffineTransform(translationX: -182, y: -428)
//                    self.animataion += 1
//
//                case 3:
//                    self.drawerImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//                    self.animataion += 1
//                default:
//                    break
//                }
//            }) { done in
//                UIView.animate(withDuration: 1.0) {
//                    self.drawerImage.transform = .identity
//                }
//            }
//        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            self.animateButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { finished in
            UIView.animate(withDuration: 0.3) {
                self.animateButton.transform = .identity
            }
        }
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
