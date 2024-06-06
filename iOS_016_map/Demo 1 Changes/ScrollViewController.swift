//
//  ScrollViewController.swift
//  Demo_iOS_005_2
//
//  Created by DREAMWORLD on 21/02/24.
//

import UIKit

class ScrollViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var tfGender: UITextField!
    @IBOutlet var tfDob: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfMobile: UITextField!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var checkBoxImage: UIImageView!
    @IBOutlet var btnSave: UIButton!
    
    var textFields = [UITextField]()
    
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Scroll View Demo"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        textFields = [tfGender, tfDob, tfEmail, tfMobile, tfName]
        
        for textField in textFields {
            textField.delegate = self
            
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 5.0
            textField.clipsToBounds = true
        }
        
        self.tfDob.setDataPickerAsInput(target: self)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapRecognizer)
        
        let checkImageBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxImageTapped))
        checkBoxImage.addGestureRecognizer(checkImageBoxTap)
        
        btnSave.layer.backgroundColor = UIColor.systemGray6.cgColor
        btnSave.layer.borderWidth = 5.0
        btnSave.layer.borderColor = UIColor.systemTeal.cgColor
        btnSave.layer.cornerRadius = 20.0
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func checkBoxImageTapped() {
        checkBoxImage.image = UIImage(named: "Checked")
        if isChecked {
            isChecked = false
            checkBoxImage.image = UIImage(named: "unChecked")
        } else {
            isChecked = true
            checkBoxImage.image = UIImage(named: "Checked")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        
        if textField == tfMobile {
            textField.keyboardAppearance = .dark
        } else {
            textField.keyboardAppearance = .default
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
}

extension UITextField {
    func setDataPickerAsInput(target: Any) {
        let ScreenWidth = UIScreen.main.bounds.width
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: ScreenWidth, height: 200))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.inputView = datePicker
        
        let tooBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: ScreenWidth, height: 50))
        let cancle = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(toolBarCancle))
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateSelected))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        tooBar.setItems([cancle, space, done], animated: true)
        self.inputAccessoryView = tooBar
    }
    
    @objc func dateSelected() {
        if let datePicker = self.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.text = dateFormatter.string(from: datePicker.date)
        }
        self.resignFirstResponder()
    }
    
    @objc func toolBarCancle() {
        self.resignFirstResponder()
    }
}
