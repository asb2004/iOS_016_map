//
//  GalleryViewController.swift
//  iOS_010
//
//  Created by DREAMWORLD on 27/02/24.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet var videoContainer: UIView!
    @IBOutlet var photoContainer: UIView!
    @IBOutlet var segmentView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoContainer.isHidden = false
        videoContainer.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if segmentView.selectedSegmentIndex == 0 {
            photoContainer.isHidden = false
            videoContainer.isHidden = true
        } else {
            photoContainer.isHidden = true
            videoContainer.isHidden = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
