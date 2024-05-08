//
//  ChangesListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 02/05/24.
//

import UIKit

let changesStoryboard = UIStoryboard(name: "Changes", bundle: .main)

class ChangesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func keyboardChangeTapped(_ sender: UIButton) {
        let vc = changesStoryboard.instantiateViewController(withIdentifier: "ScrollViewController") as! ScrollViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tabbarDemoTapped(_ sender: UIButton) {
        let vc = changesStoryboard.instantiateViewController(withIdentifier: "DefaultTabbarController") as! DefaultTabbarController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gameButtonTapped(_ sender: UIButton) {
        let vc = changesStoryboard.instantiateViewController(withIdentifier: "FruitsViewController") as! FruitsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let vc = changesStoryboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
