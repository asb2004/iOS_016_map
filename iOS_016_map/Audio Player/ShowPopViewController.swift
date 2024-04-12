//
//  ShowPopViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 05/04/24.
//

import UIKit
import ImageIO

class ShowPopViewController: UIViewController {

    @IBOutlet weak var cancleButton: UIImageView!
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 20.0
        
        cancleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancleButtonTapped)))
        
        
    }
    
    @objc func cancleButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

}
