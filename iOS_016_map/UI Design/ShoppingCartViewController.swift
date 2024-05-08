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
        initialSetup()
    }
    
    func initialSetup() {

        // basic setup
        view.backgroundColor = .white

        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(named: "tabbar_btnback")!.cgColor]
        gradientLayer.locations = [0.0, 1.0]

        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        // Set the frame to the layer
        gradientLayer.frame = view.frame

        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
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
        return 150
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            print("delete")
        }
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}
