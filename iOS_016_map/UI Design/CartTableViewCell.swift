//
//  CartTableViewCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 12/04/24.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var numberOfItemLabel: UILabel!
    @IBOutlet weak var cartProductImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 2))
        backView.layer.cornerRadius = 20.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    @IBAction func pluseButtonTapped(_ sender: UIButton) {
        if let num = numberOfItemLabel.text {
            let n = Int(num)
            numberOfItemLabel.text = "\(n! + 1)"
        }
    }
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        if let num = numberOfItemLabel.text {
            let n = Int(num)
            if n! > 0 {
                numberOfItemLabel.text = "\(n! - 1)"
            }
        }
    }
}
