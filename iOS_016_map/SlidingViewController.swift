//
//  SlidingViewController.swift
//  DrawerDemo
//
//  Created by DREAMWORLD on 29/03/24.
//

import UIKit
import NavigationDrawer

protocol SlidingViewButtonsTapped {
    func firstButtonTapped()
    func secondButtonTapped()
    func signOutButtonTapped()
}

class SlidingViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var interactor:Interactor? = nil
    var delegate: SlidingViewButtonsTapped?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func firstButtonTapped(_ sender: Any) {
        delegate?.firstButtonTapped()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func secondButtonTapped(_ sender: UIButton) {
        delegate?.secondButtonTapped()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        delegate?.signOutButtonTapped()
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
