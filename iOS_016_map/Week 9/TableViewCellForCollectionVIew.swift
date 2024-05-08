//
//  TableViewCellForCollectionVIew.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit

class TableViewCellForCollectionVIew: UITableViewCell {

    @IBOutlet weak var rowTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var setPosition: ((CGPoint) -> Void)?
    
    var colorData: [ColorData]! {
        didSet {
            self.collectionView.reloadData()
            collectionView.setContentOffset(savedContentOffset, animated: false)
        }
    }
    
    var savedContentOffset: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = ViewForColorCell()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension TableViewCellForCollectionVIew: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! CollectionViewCellForColorsList
        cell.colorTitle.text = colorData?[indexPath.row].name
        cell.colorView.backgroundColor = colorData?[indexPath.row].color
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setPosition?(scrollView.contentOffset)
    }
}

class ViewForColorCell: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            
            let itemHeight = collectionView.bounds.height
            let itemWidth = itemHeight - 40
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            minimumLineSpacing = 1
            minimumInteritemSpacing = 10
            scrollDirection = .horizontal
        }
    }
}
