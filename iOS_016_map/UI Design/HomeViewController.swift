//
//  HomeViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 09/04/24.
//

import UIKit

let uiDemoStoryboard = UIStoryboard(name: "UIDemo", bundle: nil)

class HomeViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var imageSet: [UIImage]!
    var currentIndex = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSet = [
            UIImage(named: "shop_1")!,
            UIImage(named: "shop_2")!,
            UIImage(named: "shop_3")!,
            UIImage(named: "shop_4")!,
            UIImage(named: "shop_5")!
        ]
        
        collectionVIew.layer.cornerRadius = 10.0
        collectionVIew.collectionViewLayout = ImgageSliderCustomFlow()
        
        pageControl.numberOfPages = imageSet.count
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showNextSlid), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
     
    @objc func showNextSlid() {
        if currentIndex < imageSet.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        
        collectionVIew.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
        pageControl.currentPage = currentIndex
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageSliderCell", for: indexPath) as! IamgeSliderCell
        cell.imageView.image = imageSet[indexPath.row]
        return cell
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductCell") as! HomeProductViewCell
        cell.shopImage.image = imageSet[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = uiDemoStoryboard.instantiateViewController(withIdentifier: "ProductListNav") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

class ImgageSliderCustomFlow: UICollectionViewFlowLayout {
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

