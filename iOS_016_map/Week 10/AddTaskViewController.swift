//
//  AddTaskViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 06/05/24.
//

import UIKit
import FirebaseFirestore

class AddTaskViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var doneDateImage: UIImageView!
    @IBOutlet weak var doneDateText: UILabel!
    @IBOutlet weak var createDateText: UILabel!
    @IBOutlet weak var createDataImage: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var createDateTimestamp = Timestamp(date: Date.now)
    var doneDateTimestamp = Timestamp(date: Date.now)
    var isCreateDatePicker = false
    var isDoneDatePicker = false
    
    var db = Firestore.firestore()
    var dbRef: DocumentReference!
    
    var formatter = DateFormatter()
    
    var task: Task!
    var isFromCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpControls()
        title = "Add Task"
        
        if isFromCell {
            title = "Edit Task"
            self.descriptionText.textColor = .black
            addTaskButton.setTitle("Save Changes", for: .normal)
            setTaskValues()
        }
    }
    
    func setUpControls() {
        
        self.descriptionText.layer.cornerRadius = 5.0
        self.descriptionText.text = "Enter Task Description"
        self.descriptionText.textColor = .lightGray
        
        self.datePickerView.isHidden = true
        self.datePickerView.layer.cornerRadius = 10.0
        
        formatter.dateFormat = "d-M-yyyy"
        
        createDateText.text = formatter.string(from: Date.now)
        self.createDataImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createImageTapped(_:))))
        self.doneDateImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneImageTapped(_:))))
    }
    
    func setTaskValues() {
        
        self.titleText.text = task.title
        self.descriptionText.text = task.description
        self.createDateText.text = timeToDate(from: task.createDate.seconds)
        createDateTimestamp = task.createDate
        
        if task.status {
            self.doneDateText.text = timeToDate(from: task.createDate.seconds)
            doneDateTimestamp = task.doneDate
        }
    }
    
    @objc func createImageTapped(_ sender: UITapGestureRecognizer) {
        self.datePickerView.isHidden = false
        isCreateDatePicker = true
        
        datePicker.minimumDate = nil
        datePicker.maximumDate = Date.now
    }
    
    @objc func doneImageTapped(_ sender: UITapGestureRecognizer) {
        self.datePickerView.isHidden = false
        isDoneDatePicker = true
        
        datePicker.minimumDate = Date.now
        datePicker.maximumDate = nil
    }

    @IBAction func datePicked(_ sender: UIDatePicker) {
        self.datePickerView.isHidden = true
        
        if isCreateDatePicker {
            isCreateDatePicker = !isCreateDatePicker
            createDateText.text = formatter.string(from: datePicker.date)
            createDateTimestamp = Timestamp(date: datePicker.date)
        } else {
            isDoneDatePicker = !isDoneDatePicker
            doneDateText.text = formatter.string(from: datePicker.date)
            doneDateTimestamp = Timestamp(date: datePicker.date)
        }
    }
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        guard let title = titleText.text else { return }
        
        if title.isEmpty {
            self.showAlert(with: "Enter Task Title")
            return
        }
        
        guard let description = descriptionText.text else { return }
        
        if description == "Enter Task Description" {
            self.showAlert(with: "Enter Task Description")
            return
        }
        
        var status = false
        if let date = doneDateText.text, date != "--" {
            status = true
        }
        
        var todoID = ""
        
        if isFromCell {
            todoID = task.id
        } else {
            todoID = dbRef.collection("todos").document().documentID
        }
        
        self.loader.isHidden = false
        
        let task = Task(id: todoID,
                        title: title,
                        description: description,
                        createDate: createDateTimestamp,
                        doneDate: doneDateTimestamp,
                        status: status)

        do {
            try dbRef.collection("todos").document(todoID).setData(from: task)
            self.loader.isHidden = true
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            print(error)
        }
    }
    
    func showAlert(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okay", style: .cancel))
        self.present(avc, animated: true, completion: nil)
    }
    
    func timeToDate(from seconds: Int64) -> String {
        
        let format = DateFormatter()
        format.dateFormat = "d-M-yyyy"
        return format.string(from: Date(timeIntervalSince1970: TimeInterval(seconds)))
        
    }
}

extension AddTaskViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Task Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
