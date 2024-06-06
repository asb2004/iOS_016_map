//
//  ExistingChatUser.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import UIKit

class ExistingChatUser: UITableViewCell {

    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var lastMsgLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
