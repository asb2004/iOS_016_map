//
//  PDFViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 24/04/24.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    var documentData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }

    }

}
