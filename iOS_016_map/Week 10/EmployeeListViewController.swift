//
//  EmployeeListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 30/04/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

struct Employee: Codable {
    
    var eid: String
    var name: String
    var designation: String
    var gender: String
    var mobile_no: String
    var salary: String
    var mail: String
    var profile: String
    
    init?(eid: String, name: String, designation: String, gender: String, mobile_no: String, salary: String, mail: String, profile: String) {
        self.eid = eid
        self.name = name
        self.designation = designation
        self.gender = gender
        self.mobile_no = mobile_no
        self.salary = salary
        self.mail = mail
        self.profile = profile
    }
    
    init?(dictionary: [String: Any]) {
        guard let eid = dictionary["eid"] as? String,
              let name = dictionary["name"] as? String,
              let designation = dictionary["designation"] as? String,
              let gender = dictionary["gender"] as? String,
              let mobile_no = dictionary["mobile_no"] as? String,
              let salary = dictionary["salary"] as? String,
              let profile = dictionary["profile"] as? String,
              let mail = dictionary["mail"] as? String else {
            return nil
        }
        
        self.eid = eid
        self.name = name
        self.designation = designation
        self.gender = gender
        self.mobile_no = mobile_no
        self.salary = salary
        self.mail = mail
        self.profile = profile
    }
    
}

protocol EmployeesValueChanged {
    
    func employeeAdded()
    func employeeUpdated(eid: String)
    
}

class EmployeeListViewController: UIViewController {

    @IBOutlet weak var noEmployeeLabel: UILabel!
    @IBOutlet weak var employeeTable: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    
    let ref = Database.database().reference().child("employee")
    
    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addButton.layer.cornerRadius = addButton.bounds.height / 2
        
        loader.isHidden = false
        self.getAllEmplyoeeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Employees"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func getAllEmplyoeeData() {
        self.employees.removeAll()
        
        ref.getData { err, snapshots in
            if let err = err {
                print(err)
                return
            }
            
            guard let snapshots = snapshots else {
                return
            }
            
            for case let snapshot as DataSnapshot in snapshots.children {
                if let employeeDic = snapshot.value as? [String: Any] {
                    if let employee = Employee(dictionary: employeeDic) {
                        self.employees.append(employee)
                    }
                }
            }
            
            self.loader.isHidden = true
            self.employeeTable.reloadData()
            if self.employees.isEmpty {
                self.noEmployeeLabel.isHidden = false
            } else {
                self.noEmployeeLabel.isHidden = true
            }
        }
    }
    
    func employeeAddedObserver() {
        ref.observeSingleEvent(of: .childAdded) { snapshot in
            if let employeeDic = snapshot.value as? [String: Any] {
                if let employee = Employee(dictionary: employeeDic) {
                    self.employees.append(employee)
                    self.employeeTable.reloadData()
                }
            }
        }
    }
    
    func employeeUpdatedObserver(eid: String) {
        print("update")
        let empRef = ref.child(eid)
        empRef.observe(.childChanged) { snapshot in
            print("child update")
        }
        empRef.observeSingleEvent(of: .childChanged) { snapshot in
            if let employeeDic = snapshot.value as? [String: Any] {
                if let employee = Employee(dictionary: employeeDic) {
                    print(employee)
                }
            }
        }
        ref.observeSingleEvent(of: .value) { snapshot in
            print(snapshot.childrenCount)
        }
        
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "AddEmployeeViewController") as! AddEmployeeViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
        
}

extension EmployeeListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeTable.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeCell
        cell.nameText.text = employees[indexPath.row].name
        cell.phoneText.text = employees[indexPath.row].mobile_no
        
        let url = URL(string: employees[indexPath.row].profile)
        cell.profileImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            
            let removeRef = self.ref.child(self.employees[indexPath.row].eid)
            removeRef.removeValue()
            
            if let file = URL(string: self.employees[indexPath.row].profile)?.lastPathComponent {
                let storageRef = Storage.storage().reference().child("employeeImages/\(file)")
                storageRef.delete { err in
                    if let err = err {
                        print("Error : \(err.localizedDescription)")
                    }
                }
            }
            
            
            self.employees.remove(at: indexPath.row)
            self.employeeTable.reloadData()
            
            if self.employees.isEmpty {
                self.noEmployeeLabel.isHidden = false
            } else {
                self.noEmployeeLabel.isHidden = true
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "AddEmployeeViewController") as! AddEmployeeViewController
        vc.delegate = self
        vc.forUpdate = true
        vc.employee = self.employees[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EmployeeListViewController: EmployeesValueChanged {
    func employeeUpdated(eid: String) {
        //self.employeeUpdatedObserver(eid: eid)
        self.getAllEmplyoeeData()
    }
    
    func employeeAdded() {
        self.employeeAddedObserver()
    }
    
}
