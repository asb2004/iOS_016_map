//
//  NewUserChatListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import UIKit
import SDWebImage

class NewUserChatListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var newChatUserList = [NewChatUser]()
    var delegate: NewChatRoomAdded?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadAllUserData()
    }
    
    func loadAllUserData() {
        
        ChatDBHelper.shared.getAllUser { newChatUserList, err in
            if let err = err {
                self.showAlert(with: err.localizedDescription)
                return
            }
            
            if let newChatUserList = newChatUserList {
                self.newChatUserList.removeAll()
                self.newChatUserList = newChatUserList
                self.tableView.reloadData()
            }
        }
        
    }
    
    func showAlert(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(avc, animated: true, completion: nil)
    }

}

extension NewUserChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newChatUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewUserChatCell") as! NewUserChatCell
        
        cell.userNameLbl.text = newChatUserList[indexPath.row].name
        cell.profilePicture.sd_setImage(with: URL(string: newChatUserList[indexPath.row].profile!), placeholderImage: UIImage(systemName: "person.circle"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.newChatUserSelected(otherUser: self.newChatUserList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
