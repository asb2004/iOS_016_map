//
//  ExpandableTableViewCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 24/04/24.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {

    @IBOutlet weak var answerBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var questionText: UILabel!
    
    var answerViewHeight: NSLayoutConstraint!
    
    var dataModel: FAQData! {
        didSet {
            self.questionText.text = dataModel.question
            self.answerText.text = dataModel.answer
            
            expanded = dataModel.isExpanded
        }
    }
    
    var expanded: Bool! {
        didSet {
            if expanded {
                //expandButton.setTitle("x", for: .normal)
                expandButton.setImage(UIImage(systemName: "multiply"), for: .normal)
                answerViewHeight.isActive = false
                answerBottomAnchor.constant = 15
            } else {
                //expandButton.setTitle("+", for: .normal)
                expandButton.setImage(UIImage(systemName: "plus"), for: .normal)
                answerViewHeight.isActive = true
                answerBottomAnchor.constant = 5
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        answerViewHeight = NSLayoutConstraint(item: answerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        answerView.addConstraint(answerViewHeight)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        }
    
}
