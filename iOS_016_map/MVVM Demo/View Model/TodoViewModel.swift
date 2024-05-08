//
//  TodoMVVMModel.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import Foundation
import UIKit

struct TodoViewModel {
    
    var title: String?
    var status: String?
    var buttonColor: UIColor?
    
    init(todo: TodoModel) {
        self.title = todo.title
        if todo.completed! {
            self.status = "  Completede  "
            self.buttonColor = .green
        } else {
            self.status = "  Pending  "
            self.buttonColor = .systemYellow
        }
    }
}
