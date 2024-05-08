//
//  mvvmDemoViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit

let mvvmDemoStoryboard = UIStoryboard(name: "mvvmDemo", bundle: .main)

class mvvmDemoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todos: [TodoViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MVVM"
        
        self.fetchData()
    }
    
    func fetchData() {
        APIManager.shared.fetchTodos { todoList, err in
            if let err = err {
                print("error : \(err)")
                return
            }
            
            if let todoList = todoList {
                self.todos = todoList.map({
                    return TodoViewModel(todo: $0)
                })
                self.tableView.reloadData()
            }
        }
    }

}

extension mvvmDemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mvvmTodoCell") as! TodoMVVMTableCell
        
        cell.todo = todos?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
