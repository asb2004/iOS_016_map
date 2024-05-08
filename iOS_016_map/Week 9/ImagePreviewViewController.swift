//
//  ImagePreviewViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 22/04/24.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = ImagePreviewCollectionFlow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .right, animated: true)
    }

}

extension ImagePreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePreviewCollectionViewCell", for: indexPath) as! ImagePreviewCollectionViewCell
        cell.imageView.image = imageList[indexPath.row]
        return cell
    }
}

class ImagePreviewCollectionFlow: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
                        
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
        }
    }
}



