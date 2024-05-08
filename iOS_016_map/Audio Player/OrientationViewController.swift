//
//  OrientationViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 16/04/24.
//

import UIKit

class OrientationViewController: UIViewController {

    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet var portaitContraints: [NSLayoutConstraint]!
    var landscapeContraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        leftEdge.edges = .left
        view.addGestureRecognizer(leftEdge)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            applyLandscapeConstraints()
            print("landscape")
        } else {
            applyPortraitContraints()
            print("portrait")
        }
    }
    
    func applyPortraitContraints() {
        NSLayoutConstraint.deactivate(landscapeContraints)
        view.addConstraints(portaitContraints)
    }
    
    func applyLandscapeConstraints() {
        
        NSLayoutConstraint.deactivate(portaitContraints)
        
        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false
        view3.translatesAutoresizingMaskIntoConstraints = false
        
        landscapeContraints.removeAll()
        
        let view3Bottom = NSLayoutConstraint(item: view3!, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 10)
        let view3Leading = NSLayoutConstraint(item: view3!, attribute: .left, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 10)
        let view3Right = NSLayoutConstraint(item: view3!, attribute: .right, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 10)
        let view3Height = NSLayoutConstraint(item: view3!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50)
        view.addConstraint(view3Leading)
        view.addConstraint(view3Right)
        view.addConstraint(view3Bottom)
        view.addConstraint(view3Height)
        landscapeContraints.append(view3Height)
        landscapeContraints.append(view3Leading)
        landscapeContraints.append(view3Bottom)
        landscapeContraints.append(view3Right)
        
        let view1Top = NSLayoutConstraint(item: view1!, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
        let view1Leading = NSLayoutConstraint(item: view1!, attribute: .left, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 10)
        let view1Bottom = NSLayoutConstraint(item: view1!, attribute: .bottom, relatedBy: .equal, toItem: view3, attribute: .top, multiplier: 1, constant: -10)
        let view1Width = NSLayoutConstraint(item: view1!, attribute: .width, relatedBy: .equal, toItem: view3, attribute: .width, multiplier: 0.5, constant: -5)
        view.addConstraint(view1Top)
        view.addConstraint(view1Bottom)
        view.addConstraint(view1Leading)
        view.addConstraint(view1Width)
        landscapeContraints.append(view1Width)
        landscapeContraints.append(view1Top)
        landscapeContraints.append(view1Bottom)
        landscapeContraints.append(view1Leading)
        
        let view2Top = NSLayoutConstraint(item: view2!, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
        let view2Right = NSLayoutConstraint(item: view2!, attribute: .right, relatedBy: .equal, toItem: view3, attribute: .right, multiplier: 1, constant: 0)
        let view2Bottom = NSLayoutConstraint(item: view2!, attribute: .bottom, relatedBy: .equal, toItem: view3, attribute: .top, multiplier: 1, constant: -10)
        let view2Width = NSLayoutConstraint(item: view2!, attribute: .width, relatedBy: .equal, toItem: view3, attribute: .width, multiplier: 0.5, constant: -5)
        view.addConstraint(view2Top)
        view.addConstraint(view2Right)
        view.addConstraint(view2Bottom)
        view.addConstraint(view2Width)
        landscapeContraints.append(view2Width)
        landscapeContraints.append(view2Top)
        landscapeContraints.append(view2Bottom)
        landscapeContraints.append(view2Right)
        
        
    }

}
