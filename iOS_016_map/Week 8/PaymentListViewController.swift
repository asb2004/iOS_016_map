//
//  PaymentListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 16/04/24.
//

import UIKit
import Stripe

let secrectKey = "sk_test_51NSh3ADqa0GLBBSYGkIC0oUcJyWCTF6akN0FChtP7iPHIriwkqUa6TRaVXXy22GB6OXfuTkPlENk1fZQKnMHu2M500ZFisB8ud"
let publishebalKey = "pk_test_51NSh3ADqa0GLBBSYxdZSt6AGBxCokRmkNnfsxf2H29axquOqyTCwvWGgw4GyatHYBYpou0tZSW1Qh5HIST94fgOm00A9gTZ6AE"

let week8Stroyboard = UIStoryboard(name: "week8", bundle: .main)

class PaymentListViewController: UIViewController {
    
    var customerID: String?
    var paymentIntentSecret: String?
    var empheralKey: String?
    
    var paymentSheet: PaymentSheet?

    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPayment()
    }

    @IBAction func orderNowButtonTapped(_ sender: UIButton) {
        paymentSheet?.present(from: self, completion: { paymentResult in
            switch paymentResult {
                
            case .completed:
                self.orderButton.setTitle("Payment Done Successfully", for: .normal)
                self.orderButton.backgroundColor = .green
                break
            case .canceled:
                print("canceld")
                break
            case .failed(error: let error):
                self.orderButton.setTitle("Payment Faild", for: .normal)
                print(error)
                break
            default:
                print("default")
                break
            }
        })
    }
    
    func createPayment() {
        let url = URL(string: "https://api.stripe.com/v1/customers")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer " + secrectKey, forHTTPHeaderField: "Authorization")
        
        let data: Data = "name=Abhi&email=asbabariya.weapplinse@gmail.com".data(using: .utf8)!
        
        urlRequest.httpBody = data
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Extract the paymentIntent, ephemeralKey, customer, and publishableKey from the JSON response
                    self.customerID = json["id"] as? String
                    print(self.customerID!)
                    
                    self.createEmpheralKey()
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func createEmpheralKey() {
        let url = URL(string: "https://api.stripe.com/v1/ephemeral_keys")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer " + secrectKey, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("2024-04-10", forHTTPHeaderField: "Stripe-Version")
        
        let data: Data = "customer=\(customerID!)".data(using: .utf8)!
        
        urlRequest.httpBody = data
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Extract the paymentIntent, ephemeralKey, customer, and publishableKey from the JSON response
                    self.empheralKey = json["secret"] as? String
                    print(self.empheralKey!)
                    
                    self.createPaymentIntent()
                                        
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func createPaymentIntent() {
        let url = URL(string: "https://api.stripe.com/v1/payment_intents")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer " + secrectKey, forHTTPHeaderField: "Authorization")
        
        let data: Data = "amount=1099&currency=USD&automatic_payment_methods[enabled]=true&customer=\(customerID!)".data(using: .utf8)!
        
        urlRequest.httpBody = data
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Extract the paymentIntent, ephemeralKey, customer, and publishableKey from the JSON response
                    self.paymentIntentSecret = json["client_secret"] as? String
                    print(self.paymentIntentSecret!)
                    
                    STPAPIClient.shared.publishableKey = publishebalKey
                    
                    var configuration = PaymentSheet.Configuration()
                    configuration.merchantDisplayName = "Test"
                    configuration.customer = .init(id: self.customerID!, ephemeralKeySecret: self.empheralKey!)
                    configuration.allowsDelayedPaymentMethods = true
                    self.paymentSheet = PaymentSheet(paymentIntentClientSecret: self.paymentIntentSecret!, configuration: configuration)
                    
                    DispatchQueue.main.async {
                        self.orderButton.isEnabled = true
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
