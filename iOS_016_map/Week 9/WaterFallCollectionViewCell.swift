//
//  WaterFallCollectionViewCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit

class WaterFallCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 15.0
        
    }
    
}
