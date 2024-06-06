//
//  NewUserChatCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import UIKit

class NewUserChatCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePicture.layer.cornerRadius = profilePicture.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
