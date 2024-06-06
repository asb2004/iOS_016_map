//
//  ExpandableTableViewCellViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 24/04/24.
//

import UIKit

struct FAQData {
    var question: String
    var answer: String
    var isExpanded: Bool
}

class ExpandableTableViewCellViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var faqData: [FAQData]!

    override func viewDidLoad() {
        super.viewDidLoad()

       faqData = [
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "popular belief, Lorem Ipsum is not simply random text?",
                    answer: "from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero",
                    isExpanded: false),
            FAQData(question: "you need to be sure there isn't anything embarrassing hidden in the middle of text?",
                    answer: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "you need to be sure there isn't anything embarrassing hidden in the middle of text and scrambled it to make a type specimen book?",
                    answer: "distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed.",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "here are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words.",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "here are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words.The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words?",
                    answer: "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "here are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words.here are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words.The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false),
            FAQData(question: "when an unknown printer took a galley of type and scrambled it to make a type specimen book?",
                    answer: "will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed",
                    isExpanded: false)
       ]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Expandable Table View"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

}


extension ExpandableTableViewCellViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: "ExpandableTableViewHeaderCell")!
            return cell
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: "ExpandableTableViewCell") as! ExpandableTableViewCell
            
            cell.dataModel = faqData![indexPath.row - 1]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            return
        }
        
        if faqData![indexPath.row - 1].isExpanded {
            faqData![indexPath.row - 1].isExpanded = false
            self.table.reloadRows(at: [indexPath], with: .automatic)
            return
        }
        
        for i in 0..<faqData.count {
            faqData![i].isExpanded = false
        }
        
        //let cell = table.cellForRow(at: indexPath) as! ExpandableTableViewCell
        //faqData![indexPath.row - 1].isExpanded = !faqData![indexPath.row - 1].isExpanded
        faqData![indexPath.row - 1].isExpanded = true
        //cell.expanded = true
        //self.table.reloadRows(at: [indexPath], with: .automatic)
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
