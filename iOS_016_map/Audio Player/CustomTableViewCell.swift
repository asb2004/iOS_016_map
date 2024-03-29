//
//  CustomTableViewCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 29/03/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var audioLable: UILabel!
    @IBOutlet weak var audioImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        audioImage.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
