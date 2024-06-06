//
//  WaterFallLayoutViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import Photos

class WaterFallLayoutViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageList = [
//            "img_1", "shop_1", "shop_2", "shop_3", "shop_4", "shop_5",
//            "img_1", "shop_1", "shop_2", "shop_3", "shop_4", "shop_5",
//            "img_1", "shop_1", "shop_2", "shop_3", "shop_4", "shop_5"
//        ]
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.columnCount = 2
        
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
        
        title = "Waterfall Layout"
        
        grabPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func grabPhotos(){
        imageList = []
        
        var count = 0
        
        DispatchQueue.global(qos: .background).async {
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    count += 1
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: 2000, height: 3000),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageList.append(image!)
                    })
                    if count % 10 == 0 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                    if count == 50 {
                        break
                    }
                }
            } else {
                print("You got no photos.")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
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
        cell.imageView.image = imageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return imageList[indexPath.row].size
    }
}

