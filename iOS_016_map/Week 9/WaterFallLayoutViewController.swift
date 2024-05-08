//
//  WaterFallLayoutViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class WaterFallLayoutViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageList = [
            "img_1", "shop_1", "shop_2", "shop_3", "shop_4", "shop_5",
            "img_1", "shop_1", "shop_2", "shop_3", "shop_4", "shop_5",
            "img_1", "shop_1", "shop_2", "shop_3", "shop_4", "shop_5"
        ]
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.columnCount = 2
        
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
        
        title = "Waterfall Layout"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension WaterFallLayoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waterFallCell", for: indexPath) as! WaterFallCollectionViewCell
        cell.imageView.image = UIImage(named: imageList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIImage(named: imageList[indexPath.row])!.size
    }
}

