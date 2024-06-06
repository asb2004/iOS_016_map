//
//  SignUpViewController.swift
//  
//
//  Created by DREAMWORLD on 29/04/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
//import FirebaseAnalytics

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var loingText: UILabel!
    @IBOutlet weak var confirmPassEyeImage: UIImageView!
    @IBOutlet weak var passEyeImage: UIImageView!
    @IBOutlet weak var confirmPassText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    var db = Firestore.firestore()
    
    var isPassShowing = false
    var isConfirmPassShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpControls()
    }
    
    private func setUpControls() {
        loingText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginTextTapped)))
        passEyeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(passEyeImageTapped)))
        confirmPassEyeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmPassEyeImageTapped)))
    }
    
    @objc func loginTextTapped() {
        dismiss(animated: true, completion: nil)
    }
     
    @objc func passEyeImageTapped() {
        if isPassShowing {
            self.passEyeImage.image = UIImage(systemName: "eye.slash")
            self.passwordText.isSecureTextEntry = true
        } else {
            self.passEyeImage.image = UIImage(systemName: "eye")
            self.passwordText.isSecureTextEntry = false
        }
        isPassShowing = !isPassShowing
    }
    
    @objc func confirmPassEyeImageTapped() {
        if isConfirmPassShowing {
            self.confirmPassEyeImage.image = UIImage(systemName: "eye.slash")
            self.confirmPassText.isSecureTextEntry = true
        } else {
            self.confirmPassEyeImage.image = UIImage(systemName: "eye")
            self.confirmPassText.isSecureTextEntry = false
        }
        isConfirmPassShowing = !isConfirmPassShowing
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let nameTxt = nameText.text, let emailTxt = emailText.text, let passTxt = passwordText.text, let confirmPassTxt = confirmPassText.text {
            if nameTxt.isEmpty {
                showAlert(with: "Enter Name")
                return
            }
            if emailTxt.isEmpty {
                showAlert(with: "Enter Email")
                return
            }
            if !isValidEmail(email: emailTxt) {
                showAlert(with: "Enter Valid Email Address")
                return
            }
            if passTxt.isEmpty {
                showAlert(with: "Enter Password")
                return
            }
            if !validatePassword(passTxt) {
                showAlert(with: "Enter password which must be more then 8 character long and must contain alphabet, digits and special character.")
                return
            }
            if confirmPassTxt.isEmpty {
                showAlert(with: "Enter Confirm Password")
                return
            }
            if confirmPassTxt != passTxt {
                showAlert(with: "Password and confirm password must be same.")
                return
            }

            Auth.auth().createUser(withEmail: emailTxt, password: passTxt) { result, err in
                if let err = err {
                    self.showAlert(with: err.localizedDescription)
                    return
                }
                
                if let result = result {
                    
//                    Analytics.logEvent(AnalyticsEventLogin, parameters: [
//                        AnalyticsParameterMethod: method!
//                    ])
                    
                    self.db.collection("users").document(result.user.uid).setData([
                        "name" : nameTxt,
                        "email" : emailTxt,
                        "profile" : "",
                        "uid" : result.user.uid
                    ])
                    
                    UserDefaults.standard.set("firebase", forKey: "loginFrom")

                    Switcher.updateRootVC(status: true)
                }
            }
        }
    }
    
}

extension SignUpViewController {
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
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
