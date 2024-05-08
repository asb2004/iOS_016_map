//
//  PopoverViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 05/04/24.
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var popoverButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    @IBAction func popover(_ sender: UIButton) {
        let popoverContent = CreatePopoverView()
        popoverContent.passCountry = { (country) in
            self.popoverButton.setTitle(country, for: .normal)
            
        }
        presentPopover(self, popoverContent, sender: sender, size: CGSize(width: 200, height: 200), arrowDirection: .up)
    }
    
    @IBAction func popoverButtonTapped(_ sender: Any) {
        let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "ShowPopViewController") as! ShowPopViewController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func bottomSheetTapped(_ sender: UIButton) {
        let vc = audioPlayerStoryboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30.0
            sheet.prefersGrabberVisible = true
        }
        
        present(vc, animated: true, completion: nil)
    }
}

func presentPopover(_ parentViewController: UIViewController, _ viewController: UIViewController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection = .down) {
    viewController.preferredContentSize = size
    viewController.modalPresentationStyle = .popover
    if let pres = viewController.presentationController {
        pres.delegate = parentViewController
    }
    parentViewController.present(viewController, animated: true)
    if let pop = viewController.popoverPresentationController {
        pop.sourceView = sender
        pop.sourceRect = sender.bounds
        pop.permittedArrowDirections = arrowDirection
    }
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
