//
//  SendEmailViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 15/03/24.
//

import UIKit
import MessageUI

class SendEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tvBody: UITextView!
    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var tfEmailID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmailID.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func sendEmailTapped(_ sender: Any) {
        if let email = tfEmailID.text, let subject = tfSubject.text, let body = tvBody.text {
            if !email.isEmpty && !subject.isEmpty && !body.isEmpty {
                if isValidEmail(email) {
                    if MFMailComposeViewController.canSendMail() {
                        let controller = MFMailComposeViewController()
                        controller.mailComposeDelegate = self
                        controller.setToRecipients([email])
                        controller.setSubject(subject)
                        controller.setMessageBody("<p>\(body)</p>", isHTML: true)
                        present(controller, animated: true, completion: nil)
                    }
                } else {
                    showAlter(with: "Enter Valid Email Address")
                }
            } else {
                showAlter(with: "Fill All the fields")
            }
        }
    }
    
    func showAlter(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        avc.addAction(UIAlertAction(title: "OKay", style: .default, handler: nil))
        
        present(avc, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

}

extension SendEmailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("Email Send Successfully")
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
