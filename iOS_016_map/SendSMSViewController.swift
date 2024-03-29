//
//  SendSMSViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 15/03/24.
//

import UIKit
import MessageUI

class SendSMSViewController: UIViewController {

    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var tfPhoneNo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func sendSMSButtonTapped(_ sender: UIButton) {
        
        if let phone = tfPhoneNo.text, let message = tvMessage.text {
            if !phone.isEmpty && phone.count == 10 {
                if MFMessageComposeViewController.canSendText() {
                    let controller = MFMessageComposeViewController()
                    controller.body = message
                    controller.recipients = [phone]
                    controller.messageComposeDelegate = self
                    present(controller, animated: true, completion: nil)
                }
            } else {
                showAlter(with: "Enter Valid Phone Number")
            }
        }
    }
    
    func showAlter(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        avc.addAction(UIAlertAction(title: "OKay", style: .default, handler: nil))
        
        present(avc, animated: true, completion: nil)
    }
    
}

extension SendSMSViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("message send successfully")
        
        dismiss(animated: true, completion: nil)
    }
    
}
