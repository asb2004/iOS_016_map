//
//  CreatePopoverView.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 05/04/24.
//

import UIKit

class CreatePopoverView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var passCountry: ((String) -> Void)?
    
    init() {
        super.init(nibName: "CreatePopoverView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        tableData = ["India", "US", "Autralia", "Dubai", "Chaina", "UK", "Russia", "Africa"]
    }

}

extension CreatePopoverView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passCountry!(tableData[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}


