//
//  ForgotPasswordViewController.swift
//  
//
//  Created by DREAMWORLD on 29/04/24.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func sendEmailButtonTapped(_ sender: UIButton) {
        if let emailTxt = emailText.text {
            if emailTxt.isEmpty {
                showAlert(with: "Enter Email Address")
                return
            }
            
            if !isValidEmail(email: emailTxt) {
                showAlert(with: "Enter Valid Email Address")
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: emailTxt) { err in
                if let err = err {
                    self.showAlert(with: err.localizedDescription)
                    return
                }
            }
            
            let msg = "Email send Successfully to \(emailTxt) for reset password."
            let avc = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
            avc.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(avc, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ForgotPasswordViewController {
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func showAlert(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(avc, animated: true, completion: nil)
    }
}
