//
//  BottomSheetViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 05/04/24.
//

import UIKit

class BottomSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
