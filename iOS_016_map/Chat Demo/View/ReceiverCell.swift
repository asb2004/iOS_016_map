//
//  ReceiverCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import UIKit

class ReceiverCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var msgText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        msgView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
