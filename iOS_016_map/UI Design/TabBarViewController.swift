//
//  TabBarViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 10/04/24.
//

import UIKit

protocol ControlTabbar {
    func hideTabbar()
}

class TabBarViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var homeVC: HomeViewController!
    var profileVC: ProfileViewController!
    var shoppingCartVC: ShoppingCartViewController!
    var favouriteVC: FavouriteViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.layer.cornerRadius = 20.0
        tabbarView.layer.masksToBounds = false
        tabbarView.layer.shadowColor = UIColor(named: "tabbar_lightbtn")?.cgColor
        tabbarView.layer.shadowOffset = CGSize.zero
        tabbarView.layer.shadowRadius = 10
        tabbarView.layer.shadowOpacity = 0.2
        
        reduceOpacity()
        
        homeVC = uiDemoStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
        profileVC = uiDemoStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        
        shoppingCartVC = uiDemoStoryboard.instantiateViewController(withIdentifier: "ShoppingCartViewController") as? ShoppingCartViewController
        
        favouriteVC = uiDemoStoryboard.instantiateViewController(withIdentifier: "FavouriteViewController") as? FavouriteViewController

    }
    
    func reduceOpacity() {
        homeButton.layer.opacity = 0.8
        profileButton.layer.opacity = 0.8
        cartButton.layer.opacity = 0.8
        favButton.layer.opacity = 0.8
        
        homeButton.backgroundColor = .white
        profileButton.backgroundColor = .white
        cartButton.backgroundColor = .white
        favButton.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        homeButton.layer.opacity = 1.0
        homeButton.backgroundColor = UIColor(named: "tabbar_btnback")
        
        contentView.addSubview(homeVC.view)
        homeVC.view.frame = contentView.bounds
        homeVC.didMove(toParent: self)
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        reduceOpacity()
        homeButton.layer.opacity = 1.0
        homeButton.backgroundColor = UIColor(named: "tabbar_btnback")
        
        contentView.addSubview(homeVC.view)
        homeVC.view.frame = contentView.bounds
        homeVC.didMove(toParent: self)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        reduceOpacity()
        profileButton.layer.opacity = 1.0
        profileButton.backgroundColor = UIColor(named: "tabbar_btnback")
        
        contentView.addSubview(profileVC.view)
        profileVC.didMove(toParent: self)
    }
    

    @IBAction func shoppingCartButtonTapped(_ sender: UIButton) {
        reduceOpacity()
        cartButton.layer.opacity = 1.0
        cartButton.backgroundColor = UIColor(named: "tabbar_btnback")
        
        shoppingCartVC.view.frame = contentView.bounds
        contentView.addSubview(shoppingCartVC.view)
        shoppingCartVC.didMove(toParent: self)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        reduceOpacity()
        favButton.layer.opacity = 1.0
        favButton.backgroundColor = UIColor(named: "tabbar_btnback")
        
        contentView.addSubview(favouriteVC.view)
        favouriteVC.didMove(toParent: self)
    }
}
