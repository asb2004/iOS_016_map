//
//  GeneratePDFViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 24/04/24.
//

import UIKit

class GeneratePDFViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func generatePDFButtonTapped(_ sender: UIButton) {
        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        
        let pdfCreactor = PDFCreator(title: "Hello World!",
                                     body: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.",
                                     image: UIImage(named: "expandable")!)
        vc.documentData = pdfCreactor.createFlyer()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
