//
//  PullToRefreshViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 09/04/24.
//

import UIKit

struct Hotels {
    let name: String
    let place: String
}

class PullToRefreshViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .blue
        
        return refreshControl
    }()
    
    var hotels = [
            Hotels(name: "Fairmont Grand Del Mar", place: "California south"),
            Hotels(name: "The Beverly Hills Hotel", place: "California south")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.refreshControl)

    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            
        let newHotel = Hotels(name: "Montage Laguna Beach", place:
                              "California south")
        hotels.insert(newHotel, at: 0)
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

}

extension PullToRefreshViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pullToRefreshCell")!
        
        cell.textLabel?.text = hotels[(indexPath as
                                         NSIndexPath).row].name
       cell.detailTextLabel?.text = hotels[(indexPath as
                                           NSIndexPath).row].place
    
        return cell
    }
    
    
}
