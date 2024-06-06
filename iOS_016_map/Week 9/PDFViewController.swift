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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(saveButtonTapped))

    }

    @objc func saveButtonTapped() {
        
        let filePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("webview.pdf")
        try? documentData!.write(to: filePath, options: .atomic)
        print(filePath)
        let activityViewController = UIActivityViewController(activityItems: [filePath], applicationActivities: [])
        present(activityViewController, animated: true, completion: nil)
        
    }
}
