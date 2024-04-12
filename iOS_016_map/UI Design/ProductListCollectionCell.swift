//
//  ProductListCollectionCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 10/04/24.
//

import UIKit

class ProductListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImage.layer.cornerRadius = 20.0
    }
}
