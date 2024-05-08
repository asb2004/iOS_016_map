//
//  FruitsViewController.swift
//  iOS_008_CustomTabBar
//
//  Created by DREAMWORLD on 20/03/24.
//

import UIKit

class FruitsViewController: UIViewController {
    
    @IBOutlet weak var grapesBox: UIView!
    @IBOutlet weak var bananaBox: UIView!
    @IBOutlet weak var appleBox: UIView!
    
    var appleFrame: CGRect!
    var bananaFrame: CGRect!
    var grapesFrame: CGRect!
    
    var appleImage1: UIImageView!
    var bananaImage1: UIImageView!
    var grapesImage1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleImage1 = UIImageView(image: UIImage(named: "apple"))
        appleFrame = CGRect(x: 10, y: (navigationController?.navigationBar.bounds.height)! + 50, width: 60, height: 60)
        appleImage1.frame = appleFrame
        appleImage1.contentMode = .scaleAspectFill
        appleImage1.isUserInteractionEnabled = true
        view.addSubview(appleImage1)
        
        bananaImage1 = UIImageView(image: UIImage(named: "banana"))
        bananaFrame = CGRect(x: view.bounds.width / 2 - 30, y: (navigationController?.navigationBar.bounds.height)! + 50, width: 60, height: 60)
        bananaImage1.frame = bananaFrame
        bananaImage1.contentMode = .scaleAspectFill
        bananaImage1.isUserInteractionEnabled = true
        view.addSubview(bananaImage1)
        
        grapesImage1 = UIImageView(image: UIImage(named: "grapes"))
        grapesFrame = CGRect(x: view.bounds.width - 70, y: (navigationController?.navigationBar.bounds.height)! + 50, width: 60, height: 60)
        grapesImage1.frame = grapesFrame
        grapesImage1.contentMode = .scaleAspectFill
        grapesImage1.isUserInteractionEnabled = true
        view.addSubview(grapesImage1)

        let applePanGesture = UIPanGestureRecognizer(target: self, action: #selector(applePan(_:)))
        let bananaPanGesture = UIPanGestureRecognizer(target: self, action: #selector(bananaPan(_:)))
        let grapesPanGesture = UIPanGestureRecognizer(target: self, action: #selector(grapesPan(_:)))
        appleImage1.addGestureRecognizer(applePanGesture)
        bananaImage1.addGestureRecognizer(bananaPanGesture)
        grapesImage1.addGestureRecognizer(grapesPanGesture)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    
    }
    
    @objc func applePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            appleImage1.center = CGPoint(x: appleImage1.center.x + sender.translation(in: self.view).x, y: appleImage1.center.y + sender.translation(in: self.view).y)
            sender.setTranslation(.zero, in: self.view)
        case .ended:
            if appleBox.frame.contains(appleImage1.frame) {
                UIView.animate(withDuration: 0.5) {
                    self.appleImage1.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.appleImage1.frame = self.appleFrame
                }
            }
            
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc func bananaPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            bananaImage1.center = CGPoint(x: bananaImage1.center.x + sender.translation(in: self.view).x, y: bananaImage1.center.y + sender.translation(in: self.view).y)
            sender.setTranslation(.zero, in: self.view)
        case .ended:
            print("end")
            if bananaBox.frame.contains(bananaImage1.frame) {
                print("remove")
                UIView.animate(withDuration: 0.5) {
                    self.bananaImage1.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.bananaImage1.frame = self.bananaFrame
                }
            }
            
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc func grapesPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            grapesImage1.center = CGPoint(x: grapesImage1.center.x + sender.translation(in: self.view).x, y: grapesImage1.center.y + sender.translation(in: self.view).y)
            sender.setTranslation(.zero, in: self.view)
        case .ended:
            print("end")
            if grapesBox.frame.contains(grapesImage1.frame) {
                print("remove")
                UIView.animate(withDuration: 0.5) {
                    self.grapesImage1.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.grapesImage1.frame = self.grapesFrame
                }
            }
            
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }

}
