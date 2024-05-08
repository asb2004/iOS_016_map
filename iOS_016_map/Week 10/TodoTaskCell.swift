//
//  TodoTaskCell.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 03/05/24.
//

import UIKit

class TodoTaskCell: UITableViewCell {

    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var doneDate: UILabel!
    @IBOutlet weak var createDate: UILabel!
    
    var task: Task? {
        didSet {
            self.setValuesToControls()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setValuesToControls() {
        self.taskTitle.text = task?.title
        self.taskDescription.text = task?.description
        self.createDate.text = timeToDate(from: (task?.createDate.seconds)!)
        
        if let status = task?.status {
            if status {
                self.statusImage.image = UIImage(named: "done")
                self.doneDate.text = timeToDate(from: (task?.doneDate.seconds)!)
            } else {
                self.statusImage.image = UIImage(named: "pending")
                self.doneDate.text = ""
            }
        }
    }
    
    func timeToDate(from seconds: Int64) -> String {
        
        let format = DateFormatter()
        format.dateFormat = "d-M-yyyy"
        return format.string(from: Date(timeIntervalSince1970: TimeInterval(seconds)))
        
    }

}
