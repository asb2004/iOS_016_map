//
//  ProductListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 10/04/24.
//

import UIKit

class ProductListViewController: UIViewController {

    
    @IBOutlet weak var productListCollection: UICollectionView!
    @IBOutlet weak var categoryCollecitonView: UICollectionView!
    
    var categoryImageList = [
        UIImage(named: "all")!,
        UIImage(named: "clothings")!,
        UIImage(named: "glasses")!,
        UIImage(named: "bag")!,
        UIImage(named: "shoes")!,
        UIImage(named: "watch")!,
        UIImage(named: "clothings")!,
        UIImage(named: "glasses")!,
        UIImage(named: "bag")!,
        UIImage(named: "shoes")!,
        UIImage(named: "watch")!,
    ]
    
    var categoryList = ["All", "Clothings", "Glasses", "Bags", "Shoes", "Watch", "Clothings", "Glasses", "Bags", "Shoes", "Watch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollecitonView.collectionViewLayout = CategoryCollectionFlow()
        productListCollection.collectionViewLayout = ProductListCollectionFlow()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func initialSetup() {

        view.backgroundColor = .white

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(named: "tabbar_btnback")!.cgColor]
        gradientLayer.locations = [0.0, 1.0]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.frame
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollecitonView {
            return categoryList.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.categoryCollecitonView {
            let cell = categoryCollecitonView.dequeueReusableCell(withReuseIdentifier: "CategaroyCell", for: indexPath) as! CategoryCollectionCell
            cell.categoryImage.image = categoryImageList[indexPath.row]
            cell.categoryLabel.text = categoryList[indexPath.row]
            return cell
        } else {
            let cell = productListCollection.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductListCollectionCell
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            return cell
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            cell.alpha = 1.0
            cell.transform = .identity
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productListCollection {
            let vc = uiDemoStoryboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class CategoryCollectionFlow: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            
            let itemHeight = collectionView.bounds.height
            let itemWidth = itemHeight
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
        }
    }
}

class ProductListCollectionFlow: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            
            let itemWidth = collectionView.bounds.width / 2 - 2.5
            let itemHeight = itemWidth * 1.6
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            minimumLineSpacing = 5
            minimumInteritemSpacing = 5
            scrollDirection = .vertical
        }
    }
}

