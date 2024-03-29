//
//  GoogleSignViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 15/03/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class GoogleSignViewController: UIViewController {

    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var googleButtonView: GIDSignInButton!
    
    var name = ""
    var email = ""
    var profileImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        authorizationController.performRequests()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GoogleSignViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let fullName = credential.fullName
            let email = credential.email
            
            print("Name : \(String(describing: fullName)) Email : \(String(describing: email))")
            
        }
    }
}
