//
//  MessageAlertViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 20/05/24.
//

import UIKit

class MessageAlertViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    
    var deleteForMe: (() -> ())?
    var deleteForEveryone: (() -> ())?
    var editMessage: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 10.0
    }
    
    @IBAction func deleteForEveryoneButtonTapped(_ sender: UIButton) {
        deleteForEveryone!()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteForMeButtonTapped(_ sender: UIButton) {
        deleteForMe!()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editMessageButtonTapped(_ sender: UIButton) {
        editMessage!()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
