//
//  ShoppingCartViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 10/04/24.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var orderButtonShadowView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUpControls() {
        orderButtonShadowView.layer.masksToBounds = false
        orderButtonShadowView.layer.shadowColor = UIColor(named: "tabbar_lightbtn")?.cgColor
        orderButtonShadowView.layer.shadowOffset = CGSize.zero
        orderButtonShadowView.layer.shadowRadius = 10
        orderButtonShadowView.layer.shadowOpacity = 0.2
        orderButton.layer.cornerRadius = 20.0
    }

}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            print("delete")
        }
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}
