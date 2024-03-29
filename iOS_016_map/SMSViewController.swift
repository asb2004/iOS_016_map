//
//  SMSViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 15/03/24.
//

import UIKit

class SMSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func sumOfNumbers() -> Int {
        return 10+10
    }
    
    @IBAction func SMSButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SendSMSViewController") as! SendSMSViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func emailButtonTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SendEmailViewController") as! SendEmailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        let avc  = UIAlertController(title: "Enter Phone Number for Make Phone Call", message: nil, preferredStyle: .alert)
        
        avc.addTextField { tfPhoneNo in
            tfPhoneNo.placeholder = "Enter Phone Number"
        }
        
        avc.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
            let phone = avc.textFields?.first
            
            if phone?.text?.count != 10 {
                phone?.text = ""
                phone?.placeholder = "Enter Valid Phone Number"
            } else {
                self.makePhoneCall(with: (phone?.text)!)
            }
            
        }))
        
        present(avc, animated: true, completion: nil)
    }
    
    func makePhoneCall(with phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
