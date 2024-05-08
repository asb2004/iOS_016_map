//
//  DefaultHomeViewController.swift
//  Week_2
//
//  Created by DREAMWORLD on 21/03/24.
//

import UIKit

class DefaultHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func secondVCTapped(_ sender: UIButton) {
        let vc = changesStoryboard.instantiateViewController(withIdentifier: "TabbarSecondViewController") as! TabbarSecondViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
