//
//  ShareProductCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/05/24.
//

import UIKit

class ShareProductCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.productImage.layer.cornerRadius = self.productImage.layer.bounds.height / 2
        
        backView.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
