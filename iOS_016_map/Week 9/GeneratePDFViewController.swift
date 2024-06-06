//
//  GeneratePDFViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 24/04/24.
//

import UIKit

class GeneratePDFViewController: UIViewController {

    @IBOutlet weak var pdfImage: UIImageView!
    @IBOutlet weak var bodyTxt: UITextView!
    @IBOutlet weak var titleTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTxt.text = "write your content here..."
        bodyTxt.textColor = UIColor.lightGray

    }

    @IBAction func selectImageButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func generatePDFButtonTapped(_ sender: UIButton) {
        
        guard let titleText = titleTxt.text, !titleText.isEmpty else {
            self.showAlert(with: "Enter title.")
            return
        }
        
        guard let bodyText = bodyTxt.text, bodyText != "write your content here..." else {
            self.showAlert(with: "enter some content.")
            return
        }
        
        guard let image = pdfImage.image else {
            showAlert(with: "select image.")
            return
        }
        
        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        
        let pdfCreactor = PDFCreator(title: titleText,
                                     body: bodyText,
                                     image: image)
        
        vc.documentData = pdfCreactor.createFlyer()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(with message: String) {
        
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "okay", style: .cancel, handler: nil))
        present(avc, animated: true, completion: nil)
    }
}

extension GeneratePDFViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            self.pdfImage.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension GeneratePDFViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "write your content here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}
