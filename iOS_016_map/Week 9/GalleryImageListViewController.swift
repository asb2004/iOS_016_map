//
//  GalleryImageListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 22/04/24.
//

import UIKit
import SwiftPhotoGallery
import Photos

var imageList = [UIImage]()

class GalleryImageListViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = GalleryImageCollectionFlow()
        
//        imageList = [
//            UIImage(named: "img_1")!,
//            UIImage(named: "shop_1")!,
//            UIImage(named: "shop_2")!,
//            UIImage(named: "shop_3")!,
//            UIImage(named: "shop_4")!,
//            UIImage(named: "shop_5")!,
//            UIImage(named: "img_1")!,
//            UIImage(named: "shop_1")!,
//            UIImage(named: "shop_2")!,
//            UIImage(named: "shop_3")!,
//            UIImage(named: "shop_4")!,
//            UIImage(named: "shop_5")!
//        ]
        
        loader.isHidden = false
        grabPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Gallery"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
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
                        imageList.append(image!)
                    })
                    if count % 10 == 0 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.loader.isHidden = true
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

}

extension GalleryImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryImageViewCell", for: indexPath) as! GalleryImageViewCell
        cell.imageVIew.image = imageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = week9Stroyboard.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
//        vc.selectedIndex = indexPath.row
//        navigationController?.pushViewController(vc, animated: true)
        
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.black

        gallery.hidePageControl = true

        //gallery.currentPage = indexPath.row

        gallery.modalPresentationStyle = .fullScreen
        present(gallery, animated: true, completion: { () -> Void in
            DispatchQueue.main.async {
                gallery.currentPage = indexPath.row
            }
        })
    }
}

extension GalleryImageListViewController: SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate{
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageList.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return imageList[forIndex]
    }

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    
}

class GalleryImageCollectionFlow: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            
            let itemWidth = collectionView.bounds.width / 3 - 1
            let itemHeight = itemWidth
            
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            minimumLineSpacing = 1
            minimumInteritemSpacing = 1
            scrollDirection = .vertical
        }
    }
}

