//
//  EmployeeCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 01/05/24.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var phoneText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
