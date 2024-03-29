//
//  SlidingViewController.swift
//  DrawerDemo
//
//  Created by DREAMWORLD on 29/03/24.
//

import UIKit
import NavigationDrawer

class SlidingViewController: UIViewController {
    
    var interactor:Interactor? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func homeButton(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        vc.modalPresentationStyle  = .fullScreen
//        dismiss(animated: true, completion: nil)
//        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Left)

        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.dismiss(animated: true, completion: nil)
            }
    }

}
