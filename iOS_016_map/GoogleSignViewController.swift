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

class GoogleSignViewController: UIViewController {

    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var googleButtonView: GIDSignInButton!
    @IBOutlet weak var facebookLoginView: UIView!
    
    var name = ""
    var email = ""
    var profileImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fbLoginButton = FBLoginButton()
        fbLoginButton.frame = facebookLoginView.bounds
        facebookLoginView.addSubview(fbLoginButton)
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["public_profile", "email"]

        googleButtonView.style = .wide
        googleButtonView.frame = appleButtonView.bounds
        
        let appleLoginButton = ASAuthorizationAppleIDButton()
        appleLoginButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        appleLoginButton.frame = appleButtonView.bounds
        appleButtonView.addSubview(appleLoginButton)
    }
    
    @IBAction func GoogleButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { resutl, error in

            guard error == nil else { return }

            guard let signInResult = resutl else { return }

            let user = signInResult.user

            self.email = user.profile?.email ?? ""
            self.name = user.profile?.name ?? ""
            self.profileImageURL = user.profile?.imageURL(withDimension: 320)
            
            UserDefaults.standard.set("google", forKey: "loginFrom")

            Switcher.updateRootVC(status: true)
        }
    }
    
    @objc func appleLoginTapped() {
        
        let vc = SMSViewController()
        print(vc.sumOfNumbers())
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let fullName = credential.fullName?.givenName
            let email = credential.email
            
            print("Name : \(String(describing: fullName)) Email : \(String(describing: email))")
            
        }
    }
}
