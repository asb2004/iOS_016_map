//
//  mvcDemoViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit
import Stripe

let mvcDemoStoryboard = UIStoryboard(name: "mvcDemo", bundle: .main)

class mvcDemoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todos: [Todo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MVC"
        
        self.fetchData()
    }
    
    func fetchData() {
        Service.shared.fetchTodos { todoList, err in
            if let err = err {
                print("error : \(err)")
                return
            }
            
            if let todoList = todoList {
                self.todos = todoList
                self.tableView.reloadData()
            }
        }
    }
    
}

extension mvcDemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoTableCell
        
        cell.showData(todo: (self.todos?[indexPath.row])!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
