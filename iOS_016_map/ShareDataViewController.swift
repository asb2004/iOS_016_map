//
//  ShareDataViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 19/03/24.
//

import UIKit

class ShareDataViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var txtMessage: UITextField!
    
    var isPostPicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtMessage.layer.cornerRadius = 10.0
        txtMessage.delegate = self
        
        postImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postImageTapped)))
    }
    
    @IBAction func whatsAppButtonTapped(_ sender: UIButton) {
        if let message = txtMessage.text {
            if message != "" {
                let escapedMesage = message.addingPercentEncoding(withAllowedCharacters:  .urlQueryAllowed)!
                //let urlString = "whatsapp://send?text=\(escapedMesage)"
                if let whatsappURL = URL(string: "whatsapp://send?text=\(escapedMesage)") {
                     if UIApplication.shared.canOpenURL(whatsappURL) {
                         UIApplication.shared.open(whatsappURL, options: [: ], completionHandler: nil)
                     } else {
                         let avc = UIAlertController(title: "Please Install Whatsapp", message: nil, preferredStyle: .alert)
                         avc.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                         present(avc, animated: true, completion: nil)
                     }
                 }
            } else {
                let avc = UIAlertController(title: "Enter Message", message: nil, preferredStyle: .alert)
                avc.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                present(avc, animated: true, completion: nil)
            }
        }
    }

    @IBAction func instagramButtonTapped(_ sender: Any) {
        
        if !isPostPicked {
            let avc = UIAlertController(title: "Please Select Image", message: nil, preferredStyle: .alert)
            avc.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                return
            }))
            present(avc, animated: true, completion: nil)
            
        }
        
        
        guard let image = postImage.image else {
            print("Image not found!")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        // If you want to exclude certain sharing options, you can specify them here
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .postToFlickr
        ]
        
         //Present the view controller
        present(activityViewController, animated: true)
        
        
//        let instagramURL = URL(string: "instagram-stories://share")
//        let imageData = UIImage(named: "img_1")?.jpegData(compressionQuality: 1.0)
//
//        if UIApplication.shared.canOpenURL(instagramURL!) {
//            let paste = [["com.instagram.sharedSticker.stickerImage": imageData]]
//            UIPasteboard.general.setItems(paste, options: [.expirationDate: Date().addingTimeInterval(300)])
//            UIApplication.shared.open(instagramURL!)
//        }
//
//        if UIApplication.shared.canOpenURL(instagramURL!) {
//            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//            let saveImagePath = (docDir as NSString).strings(byAppendingPaths: ["Image.igo"])[0]
//            let imageData = postImage.image?.pngData()
//
//            do{
//                try imageData?.write(to: URL(string: saveImagePath)!)
//            } catch {
//                fatalError("error \(error)")
//            }
//
//            let imageURL = URL(fileURLWithPath: saveImagePath)
//            let docInteractionController = UIDocumentInteractionController()
//            docInteractionController.url = imageURL
//            docInteractionController.uti = "com.instagram.exclusivegram"
//            docInteractionController.annotation = ["InstagramCaption" : "Testing"]
//
//
//            if !docInteractionController.presentOpenInMenu(from: view.bounds, in: self.view, animated: true) {
//                print("Instagram not found")
//            }
//
//        }
        
//        DispatchQueue.main.async {
//
//            //Share To Instagram:
//            let instagramURL = URL(string: "instagram://")
//            if UIApplication.shared.canOpenURL(instagramURL!) {
//
//                let imageData = UIImage(named: "img_1")!.jpegData(compressionQuality: 100)
//                let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.ig")
//
//                do {
//                    try imageData?.write(to: URL(fileURLWithPath: writePath), options: .atomic)
//                } catch {
//                    print(error)
//                }
//
//                let fileURL = URL(fileURLWithPath: writePath)
//                let documentController = UIDocumentInteractionController(url: fileURL)
//                documentController.delegate = self
//                documentController.uti = "com.instagram.photo"
//
//                documentController.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
//            } else {
//                print(" Instagram is not installed ")
//            }
//        }
        
    }
    
    @objc func postImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ShareDataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ShareDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            postImage.image = image
            isPostPicked = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ShareDataViewController: UIDocumentInteractionControllerDelegate {
    
}
