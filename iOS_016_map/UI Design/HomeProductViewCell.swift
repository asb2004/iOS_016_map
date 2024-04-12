//
//  HomeProductViewCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 10/04/24.
//

import UIKit

class HomeProductViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var shopImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 15.0
        shopImage.layer.cornerRadius = 10.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
