//
//  TodoMVVM.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import Foundation

struct TodoModel: Decodable {
    var userId : Int?
    var id : Int?
    var title : String?
    var completed : Bool?
}
