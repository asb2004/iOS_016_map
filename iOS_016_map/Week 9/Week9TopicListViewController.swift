//
//  Week9TopicListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 22/04/24.
//

import UIKit

let week9Stroyboard = UIStoryboard(name: "week9", bundle: .main)

class Week9TopicListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func galleryVIewButtonTapped(_ sender: UIButton) {
        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "GalleryImageListViewController") as! GalleryImageListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mvcButtonTapped(_ sender: UIButton) {
        let vc = mvcDemoStoryboard.instantiateViewController(withIdentifier: "mvcDemoViewController") as! mvcDemoViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mvvmButtonTapped(_ sender: UIButton) {
        let vc = mvvmDemoStoryboard.instantiateViewController(withIdentifier: "mvvmDemoViewController") as! mvvmDemoViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func waterFallButtonTapped(_ sender: UIButton) {
        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "WaterFallLayoutViewController") as! WaterFallLayoutViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func expandableButtonTapped(_ sender: UIButton) {
        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "ExpandableTableViewCellViewController") as! ExpandableTableViewCellViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func collectionViewInsideTableTapped(_ sender: UIButton) {
        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "CollectionViewInsideTableViewController") as! CollectionViewInsideTableViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pdfGenerateButtontTapped(_ sender: UIButton) {
        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "GeneratePDFViewController") as! GeneratePDFViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
