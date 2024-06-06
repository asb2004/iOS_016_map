//
//  TodoListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 03/05/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import CoreMedia

struct Task: Codable {
    var id: String
    var title: String
    var description: String
    var createDate: Timestamp
    var doneDate: Timestamp
    var status: Bool
    
    init?(TaskDict: [String: Any]) {
        guard let id = TaskDict["id"] as? String,
           let title = TaskDict["title"] as? String,
           let description = TaskDict["description"] as? String,
           let createDate = TaskDict["createDate"] as? Timestamp,
           let doneDate = TaskDict["doneDate"] as? Timestamp,
           let status = TaskDict["status"] as? Bool else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        self.createDate = createDate
        self.doneDate = doneDate
        self.status = status
    }
    
    init?(id: String, title: String, description: String, createDate: Timestamp, doneDate: Timestamp, status: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.createDate = createDate
        self.doneDate = doneDate
        self.status = status
    }
}

class TodoListViewController: UIViewController {

    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var todosList = [Task]()
    
    var userID: String!
    var db = Firestore.firestore()
    var dbRef: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userID = Auth.auth().currentUser?.uid
        
        dbRef = db.collection("users").document(userID)
    }
    
    func getTodos() {
        todosList.removeAll()
        dbRef.collection("todos").order(by: "createDate", descending: true).getDocuments { [self] snapshots, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let snapshots = snapshots?.documents {
                for snapshot in snapshots {
                    let data = snapshot.data()
                    self.todosList.append(Task(TaskDict: data)!)
                }
                self.loader.isHidden = true
                self.tableView.reloadData()
                if todosList.isEmpty {
                    noTaskLabel.isHidden = false
                } else {
                    noTaskLabel.isHidden = true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Todo List"
        
        loader.isHidden = false
        getTodos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false

    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        vc.dbRef = self.dbRef
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTaskCell") as! TodoTaskCell
        cell.task = todosList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") { action, view, completion in
            self.dbRef.collection("todos").document(self.todosList[indexPath.row].id).delete { err in
                if let err = err {
                    print(err.localizedDescription)
                }
                
                self.todosList.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                if self.todosList.isEmpty {
                    self.noTaskLabel.isHidden = false
                } else {
                    self.noTaskLabel.isHidden = true
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = week10Storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        vc.dbRef = self.dbRef
        vc.task = todosList[indexPath.row]
        vc.isFromCell = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
