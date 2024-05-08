//
//  AddEmployeeViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 01/05/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class AddEmployeeViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var empSalaryText: UITextField!
    @IBOutlet weak var empDesignationText: UITextField!
    @IBOutlet weak var empGenderText: UITextField!
    @IBOutlet weak var empPhoneText: UITextField!
    @IBOutlet weak var empEmailText: UITextField!
    @IBOutlet weak var empNameText: UITextField!
    @IBOutlet weak var employeeImage: UIImageView!
    
    var imageURL: URL!
    var isImagePicked = false
    
    var delegate: EmployeesValueChanged?
    
    let ref = Database.database().reference().child("employee")
    
    var employee: Employee!
    var forUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpControls()
        
        if forUpdate {
            title = "Edit Employee Details"
            self.saveButton.isEnabled = false
            self.loadEmployee()
            self.saveButton.setTitle("Save Changes", for: .normal)
        }
        
    }
    
    func setUpControls() {
        
        self.employeeImage.layer.cornerRadius = self.employeeImage.bounds.height / 2
        self.employeeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(employeeImageTapped)))
        
    }
    
    func loadEmployee() {
        
        guard let employee = employee else { return }
        
        let url = URL(string: employee.profile)
        self.employeeImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person"))
        self.empNameText.text = employee.name
        self.empEmailText.text = employee.mail
        self.empPhoneText.text = employee.mobile_no
        self.empGenderText.text = employee.gender
        self.empDesignationText.text = employee.designation
        self.empSalaryText.text = employee.salary
    }
    
    @objc func employeeImageTapped() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Add Employee Details"
    }
    
    func uploadImageToCloudStorage(with fileURL: URL, name: String, complition: @escaping ((URL) -> ())) {
        
        let imgExtension = fileURL.pathExtension
        let storageRef = Storage.storage().reference().child("employeeImages/\(name)\(UUID().uuidString).\(imgExtension)")
        
        storageRef.putFile(from: fileURL, metadata: nil) { metadata, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            storageRef.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                if let url = url {
                    complition(url)
                }
            }
        }
    }
    
    func saveEmployeeDetails(employee: Employee) {
    
        do {
            let empRef = ref.childByAutoId()
            
            var emp = employee
            emp.eid = empRef.key!
            
            let data = try JSONEncoder().encode(emp)
            let json = try JSONSerialization.jsonObject(with: data)

            empRef.setValue(json)
            self.loader.isHidden = true
            delegate?.employeeAdded()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func updateEmployeeDetails(employee: Employee) {
        
        do {
            let data = try JSONEncoder().encode(employee)
            let json = try JSONSerialization.jsonObject(with: data) as! [AnyHashable : Any]
            
            let empRef = ref.child(employee.eid)
            empRef.updateChildValues(json) { err, dataRef in
                
                if let err = err {
                    print("Employee details not updated with error : \(err.localizedDescription)")
                    return
                }

                self.loader.isHidden = true
                self.delegate?.employeeUpdated(eid: employee.eid)
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let name = empNameText.text,
           let email = empEmailText.text,
           let phone = empPhoneText.text,
           let gender = empGenderText.text,
           let designation = empDesignationText.text,
           let salary = empSalaryText.text {
            
            if !forUpdate {
                if !isImagePicked {
                    showAlert(with: "Select Profile image")
                }
            }
            
            if name.isEmpty || email.isEmpty || phone.isEmpty || gender.isEmpty || designation.isEmpty || salary.isEmpty {
                showAlert(with: "Please fill all fields.")
                return
            }
            
            if !isValidEmail(email: email) {
                showAlert(with: "Enter Valid email address.")
                return
            }
            
            if phone.count != 10 {
                showAlert(with: "Enter Valid Phone Number.")
                return
            }
            
            if forUpdate {
                
                self.employee.name = name
                self.employee.salary = salary
                self.employee.designation = designation
                self.employee.gender = gender
                self.employee.mobile_no = phone
                self.employee.mail = email
                
                if isImagePicked {
                    if let file = URL(string: self.employee.profile)?.lastPathComponent {
                        let storageRef = Storage.storage().reference().child("employeeImages/\(file)")
                        storageRef.delete { err in
                            if let err = err {
                                print("Error : \(err.localizedDescription)")
                            }
                        }
                    }
                    loader.isHidden = false
                    uploadImageToCloudStorage(with: imageURL, name: name) { url in
                        self.employee.profile = "\(url)"
                        self.updateEmployeeDetails(employee: self.employee)
                    }
                } else {
                    loader.isHidden = false
                    self.updateEmployeeDetails(employee: self.employee)
                }
            } else {
                loader.isHidden = false
                uploadImageToCloudStorage(with: imageURL, name: name) { url in
                    let emp = Employee(eid: "", name: name, designation: designation, gender: gender, mobile_no: phone, salary: salary, mail: email, profile: "\(url)")
                    self.saveEmployeeDetails(employee: emp!)
                }
            }
            
            
            
            //let emp = Employee(eid: "", name: name, designation: designation, gender: gender, mobile_no: phone, salary: salary, mail: email, profile: "")
            
            //loader.isHidden = false
            //uploadImageToCloudStorage(with: imageURL, employee: emp!)
            
        }
    }
}

extension AddEmployeeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.employeeImage.image = image
        }
        self.imageURL = info[.imageURL] as? URL
        self.isImagePicked = true
        
        if self.forUpdate {
            self.saveButton.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddEmployeeViewController {
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func showAlert(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(avc, animated: true, completion: nil)
    }
}

extension AddEmployeeViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if forUpdate {
            
            if employee.name == empNameText.text &&
                employee.mail == empEmailText.text &&
                employee.designation == empDesignationText.text &&
                employee.mobile_no == empPhoneText.text &&
                employee.salary == empSalaryText.text &&
                employee.gender == empGenderText.text {
                self.saveButton.isEnabled = false
            } else {
                self.saveButton.isEnabled = true
            }
            
            
//            switch textField {
//            case empNameText:
//                if employee.name != empNameText.text {
//                    self.saveButton.isEnabled = true
//                }
//                break
//
//            case empEmailText:
//                if employee.mail != empEmailText.text {
//                    self.saveButton.isEnabled = true
//                }
//                break
//
//            case empDesignationText:
//                if employee.designation != empDesignationText.text {
//                    self.saveButton.isEnabled = true
//                }
//                break
//
//            case empPhoneText:
//                if employee.mobile_no != empPhoneText.text {
//                    self.saveButton.isEnabled = true
//                }
//                break
//
//            case empSalaryText:
//                if employee.salary != empSalaryText.text {
//                    self.saveButton.isEnabled = true
//                }
//                break
//
//            case empGenderText:
//                if employee.gender != empGenderText.text {
//                    self.saveButton.isEnabled = true
//                }
//                break
//
//            default:
//                break
//            }
        }
        
    }
    
}
