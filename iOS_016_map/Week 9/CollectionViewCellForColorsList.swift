//
//  CollectionViewCellForColorsList.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit

class CollectionViewCellForColorsList: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 10.0
        
    }
    
}
