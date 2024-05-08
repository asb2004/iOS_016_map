//
//  Week10TopicListController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 26/04/24.
//

import UIKit
import BarcodeScanner

let week10Storyboard = UIStoryboard(name: "week10", bundle: .main)

class Week10TopicListController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func textToSpeechButtonTapped(_ sender: UIButton) {
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "TextToSpeechViewController") as! TextToSpeechViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func speechToTextButtonTapped(_ sender: UIButton) {
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "SpeechToTextViewController") as! SpeechToTextViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func codeScannerButtonTapped(_ sender: UIButton) {
//        let vc = week10Storyboard.instantiateViewController(withIdentifier: "BarcodeScaningController") as! BarcodeScaningController
//        navigationController?.pushViewController(vc, animated: true)
        
        let barcoadView = BarcodeScannerViewController()
        barcoadView.codeDelegate = self
        barcoadView.errorDelegate = self
        barcoadView.dismissalDelegate = self

        present(barcoadView, animated: true, completion: nil)
    }
    
    @IBAction func realTimeDatabaseButtonTapped(_ sender: UIButton) {
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "EmployeeListViewController") as! EmployeeListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func firestoreDatabaseTapped(_ sender: UIButton) {
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "TodoListViewController") as! TodoListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(avc, animated: true, completion: nil)
    }
}

extension Week10TopicListController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        dismiss(animated: true, completion: nil)
        self.showAlert(message: "Code: \(code)")
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        dismiss(animated: true, completion: nil)
        self.showAlert(message: "Error: \(error.localizedDescription)")
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
