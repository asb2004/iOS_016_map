//
//  TodoTableCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit

class TodoTableCell: UITableViewCell {

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func showData(todo: Todo) {
        self.titleLabel.text = todo.title
        if todo.completed! {
            statusButton.setTitle("Completed", for: .normal)
            statusButton.tintColor = .green
        } else {
            statusButton.setTitle("Pending", for: .normal)
            statusButton.tintColor = .systemYellow
        }
    }
}
