//
//  TodoMVVMTableCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit

class TodoMVVMTableCell: UITableViewCell {

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var todo: TodoViewModel! {
        didSet {
            self.titleLabel.text = todo.title
            self.statusButton.setTitle(todo.status, for: .normal)
            self.statusButton.backgroundColor = todo.buttonColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
