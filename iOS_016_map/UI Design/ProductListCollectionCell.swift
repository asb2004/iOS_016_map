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
    @IBAction func favButtonTapped(_ sender: UIButton) {
        
        if sender.imageView?.image == UIImage(systemName: "heart") {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            sender.configuration?.baseForegroundColor = .red
        } else {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            sender.configuration?.baseForegroundColor = .darkGray
        }
        
    }
    
    @IBAction func bagButtonTapped(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "bag") {
            sender.setImage(UIImage(systemName: "bag.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bag"), for: .normal)
        }
    }
}
