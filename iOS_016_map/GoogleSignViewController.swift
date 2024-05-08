//
//  GoogleSignViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 15/03/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import CryptoKit

class GoogleSignViewController: UIViewController {

    @IBOutlet weak var registerText: UILabel!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var forgotText: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var googleButtonView: GIDSignInButton!
    @IBOutlet weak var facebookLoginView: UIView!
    
    var isPassShowing = false
    
    var name = ""
    var email = ""
    var profileImageURL: URL?
    
    var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpControls()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fbLoginButton = FBLoginButton()
        fbLoginButton.frame = facebookLoginView.bounds
        facebookLoginView.addSubview(fbLoginButton)
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["public_profile", "email"]

        googleButtonView.style = .standard
        googleButtonView.frame = googleButtonView.bounds
        
        let appleLoginButton = ASAuthorizationAppleIDButton()
        appleLoginButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        appleLoginButton.frame = appleButtonView.bounds
        appleButtonView.addSubview(appleLoginButton)
    }
    
    private func setUpControls() {
        eyeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eyeTapped)))
        registerText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(registerTextTapped)))
        forgotText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotTextTapped)))
    }
    
    @objc func eyeTapped() {
        if isPassShowing {
            self.eyeImage.image = UIImage(systemName: "eye.slash")
            self.passwordText.isSecureTextEntry = true
        } else {
            self.eyeImage.image = UIImage(systemName: "eye")
            self.passwordText.isSecureTextEntry = false
        }
        isPassShowing = !isPassShowing
    }
    
    @objc func registerTextTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func forgotTextTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        if let emailTxt = emailText.text, let passTxt = passwordText.text {
            if emailTxt.isEmpty {
                showAlert(with: "Enter Email Address")
                return
            }
            
            if passTxt.isEmpty {
                showAlert(with: "Enter Password")
                return
            }
            
            if !isValidEmail(email: emailTxt) {
                showAlert(with: "Enter valid email address")
                return
            }
            
            if !validatePassword(passTxt) {
                showAlert(with: "Enter password which must be more then 8 character long and must contain alphabet, digits and special character.")
                return
            }
            
            FirebaseAuth.Auth.auth().signIn(withEmail: emailTxt, password: passTxt) { result, err in
                if let _ = err {
                    self.showAlert(with: "provided credential are not valid. try again with valid credential!")
                    return
                }
                
                if let result = result {
                    print(result.user.email!)
                    print(result.user.uid)
                    
                    UserDefaults.standard.set("firebase", forKey: "loginFrom")

                    Switcher.updateRootVC(status: true)
                }
            }
        }
    }
    
    @IBAction func GoogleButtonTapped(_ sender: Any) {
        print("google")
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { resutl, error in
//
//            guard error == nil else { return }
//
//            guard let signInResult = resutl else { return }
//
//            let user = signInResult.user
//
//            self.email = user.profile?.email ?? ""
//            self.name = user.profile?.name ?? ""
//            self.profileImageURL = user.profile?.imageURL(withDimension: 320)
//
//            UserDefaults.standard.set("google", forKey: "loginFrom")
//
//            Switcher.updateRootVC(status: true)
//        }
        
    
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in

            guard error == nil else { return }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, err in
                if let err = err {
                    self.showAlert(with: err.localizedDescription)
                }
                if let result = result {
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(result.user.uid).setData([
                        "name" : user.profile!.name as String,
                        "email" : result.user.email! as String
                    ])
                    
                    UserDefaults.standard.set("firebase", forKey: "loginFrom")

                    Switcher.updateRootVC(status: true)
                }

            }
            
        }
    }
    
    @objc func appleLoginTapped() {
        
//        let vc = SMSViewController()
//        print(vc.sumOfNumbers())
//
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
        
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }


}

extension GoogleSignViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let result = result {
            if result.isCancelled {
                print("user cancle")
                return
            }
            UserDefaults.standard.set("facebook", forKey: "loginFrom")
            Switcher.updateRootVC(status: true)
            //getUserData()
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("log out")
    }
    
    
}

extension GoogleSignViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//
//            let fullName = credential.fullName?.givenName
//            let email = credential.email
//
//            print("Name : \(String(describing: fullName)) Email : \(String(describing: email))")
//
//        }
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("unable to find identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("nable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            Auth.auth().signIn(with: credential) { result, err in
                if let err = err {
                    print(err.localizedDescription)
                    self.showAlert(with: err.localizedDescription)
                    return
                }
                
                if let result = result {
                    print(result.user.email!)
                    print(appleIDCredential.fullName?.givenName!)
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(result.user.uid).setData([
                        "name" : appleIDCredential.email!,
                        "email" : appleIDCredential.fullName!
                    ])
                    
                    UserDefaults.standard.set("firebase", forKey: "loginFrom")

                    Switcher.updateRootVC(status: true)
                }
            }
        }
        
    }
}

extension GoogleSignViewController {
    
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
