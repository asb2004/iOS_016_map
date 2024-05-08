//
//  APIManager.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import Foundation

class APIManager: NSObject {
    
    static let shared = APIManager()
    
    func fetchTodos(completion: @escaping ([TodoModel]?, Error?) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                return
            }

            do {
                let courses = try JSONDecoder().decode([TodoModel].self, from: data)
                DispatchQueue.main.async {
                    completion(courses, nil)
                }
            } catch let jsonErr {
                print("Erro : \(jsonErr)")
            }
        }.resume()
    }
}
