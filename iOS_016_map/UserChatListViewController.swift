//
//  UserChatListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

var currentUserID = ""

let chatDemoStoryboard = UIStoryboard(name: "chatDemo", bundle: .main)

protocol NewChatRoomAdded {
    
    func newChatUserSelected(otherUser: NewChatUser)
    
}

class UserChatListViewController: UIViewController {

    @IBOutlet weak var noChatLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewChatButton: UIButton!
    
    var connectedUserList: [ChatUser]!
    
    var db = Firestore.firestore()
    var chatObserver: ListenerRegistration?
    var lastMessageObserver: ListenerRegistration?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        connectedUserList = [ChatUser]()
        
        self.getCurrentUserID()
        
        self.setupControlls()
        //self.getConnectedUserList()
        
        
    }
    
    func getCurrentUserID() {
        
        if Auth.auth().currentUser != nil {
            currentUserID = Auth.auth().currentUser!.uid
        }
        
    }
    
    func getConnectedUserList() {
        ChatDBHelper.shared.getConnectedUser { users, err in
            if let err = err {
                self.showAlert(with: err.localizedDescription)
                return
            }
            
            if let users = users {
                if users.isEmpty {
                    print("No Chats Available")
                    return
                }
                self.connectedUserList.removeAll()
                self.connectedUserList = users
                self.connectedUserList.sort { $0.time!.seconds > $1.time!.seconds }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        chatObserver?.remove()
        connectedUserList.removeAll()
        let chatRef = db.collection("users").document(currentUserID).collection("chat")
        chatObserver = chatRef.order(by: "time", descending: true).addSnapshotListener({ queryListener, err in
            if let err = err {
                self.showAlert(with: err.localizedDescription)
                return
            }
            
            if let queryListener = queryListener {
                
                if queryListener.isEmpty {
                    if self.connectedUserList.isEmpty {
                        self.noChatLabel.isHidden = false
                    } else {
                        self.noChatLabel.isHidden = true
                    }
                    return
                }
                
                for documentChanges in queryListener.documentChanges {
                    if documentChanges.type == .added {
                        let userRef = self.db.collection("users")
                        userRef.whereField("uid", isEqualTo: documentChanges.document.documentID).getDocuments { userDocument, err in
                            if let err = err {
                                self.showAlert(with: err.localizedDescription)
                                return
                            }
                            
                            if let userDocument = userDocument {
                                for userData in userDocument.documents {
                                    
                                    var user = userData.data()
                                    user["last_message"] = documentChanges.document.data()["last_message"]
                                    user["time"] = documentChanges.document.data()["time"]

                                    self.connectedUserList.insert(ChatUser(data: user)!, at: 0)
                                    self.tableView.reloadData()
                                }
                                
                                if self.connectedUserList.isEmpty {
                                    self.noChatLabel.isHidden = false
                                } else {
                                    self.noChatLabel.isHidden = true
                                }
                            }
                        }
                    } else if documentChanges.type == .modified {
                        let otherUserId = documentChanges.document.documentID
                        if let index = self.connectedUserList.firstIndex(where: { $0.uid == otherUserId }) {
                            
                            var otherUser = self.connectedUserList.remove(at: index)
                            
                            otherUser.last_message = documentChanges.document.data()["last_message"] as? String
                            otherUser.time = documentChanges.document.data()["time"] as? Timestamp
                            
                            self.connectedUserList.insert(otherUser, at: 0)
                            self.tableView.reloadData()
                            
                            if self.connectedUserList.isEmpty {
                                self.noChatLabel.isHidden = false
                            } else {
                                self.noChatLabel.isHidden = true
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        chatObserver?.remove()
    }
    
    func setupControlls() {
        
        self.addNewChatButton.layer.cornerRadius = 20.0
        
    }
    
    @IBAction func addNewChatButtonTapped(_ sender: UIButton) {
        let vc = chatDemoStoryboard.instantiateViewController(withIdentifier: "NewUserChatListViewController") as! NewUserChatListViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func showAlert(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(avc, animated: true, completion: nil)
    }
    
    func getDateString(from time: Timestamp) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(time.seconds))
        
        let calender = Calendar.current
        var calenderComponent = calender.dateComponents([.day, .month, .year], from: date)
        let messageDate = calender.date(from: calenderComponent)
        
        calenderComponent = calender.dateComponents([.day, .month, .year], from: Date.now)
        let currentDate = calender.date(from: calenderComponent)
        
        let formatter = DateFormatter()
        
        if messageDate == currentDate {
            formatter.dateFormat = "hh:mm a"
        } else {
            formatter.dateFormat = "d-M-yyyy"
        }
        
        return formatter.string(from: date)
        
    }
    
}

extension UserChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingChatUser") as! ExistingChatUser
        cell.profilePic.sd_setImage(with: URL(string: connectedUserList[indexPath.row].profile!), placeholderImage: UIImage(systemName: "person.circle"))
        cell.nameLbl.text = connectedUserList[indexPath.row].name
        cell.lastMsgLbl.text = connectedUserList[indexPath.row].last_message
        cell.timelbl.text = getDateString(from: connectedUserList[indexPath.row].time!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = chatDemoStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.otherUser = connectedUserList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension UserChatListViewController: NewChatRoomAdded {
    
    func newChatUserSelected(otherUser: NewChatUser) {
        
        ChatDBHelper.shared.createNewChatRoom(with: otherUser.uid)
        
        let vc = chatDemoStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let otherChatUser = ChatUser(name: otherUser.name,
                                     email: otherUser.email,
                                     profile: otherUser.profile,
                                     uid: otherUser.uid,
                                     time: nil, lastMessage: nil)
        vc.otherUser = otherChatUser
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
