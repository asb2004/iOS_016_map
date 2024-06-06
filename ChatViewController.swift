//
//  ChatViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import UIKit
import SDWebImage
import FirebaseFirestore
import AVFoundation
import AVKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {

    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var userOnlineStatus: UILabel!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var otherProfileName: UILabel!
    @IBOutlet weak var otherProfilePic: UIImageView!
    
    private let maxHeight: CGFloat = 100
    private let minHeight: CGFloat = 40
    
    var db = Firestore.firestore()
    var msgObserver: ListenerRegistration?
    var userStatusObserver: ListenerRegistration?
    
    var messages = [Message]()
    
    var otherUser: ChatUser?
    
    var isMessageEditing = false
    var mid = ""
    var isLastMessage = false
    var time: Timestamp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageText.text = "Enter Message"
        messageText.textColor = UIColor.lightGray
        messageText.layer.cornerRadius = 5.0
        
        self.setupControlls()
        
        tableVIew.register(UINib(nibName: "MediaSenderCell", bundle: nil), forCellReuseIdentifier: "MediaSenderCell")
        tableVIew.register(UINib(nibName: "MediaReceiverCell", bundle: nil), forCellReuseIdentifier: "MediaReceiverCell")
        
        if let otherUser = otherUser {
            
            //self.loadAllMessages()
            
            self.otherProfilePic.sd_setImage(with: URL(string: otherUser.profile!), placeholderImage: UIImage(systemName: "person.circle"))
            self.otherProfileName.text = otherUser.name
            
            let msgRef = db.collection("users").document(currentUserID).collection("chat").document(otherUser.uid).collection("messages")
            
            msgObserver?.remove()
            
            msgObserver = msgRef.order(by: "time").addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                if let querySnapshot = querySnapshot {
                    for snapshot in querySnapshot.documentChanges {
                        if snapshot.type == .added {
                            self.messages.append(Message(data: snapshot.document.data())!)
                            self.tableVIew.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .fade)
                            //self.tableVIew.reloadData()
                            if !self.messages.isEmpty {
                                self.tableVIew.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
                            }
                        } else if snapshot.type == .modified {
                            if let message = Message(data: snapshot.document.data()) {
                                let index = self.messages.firstIndex(where: { $0.mid == message.mid })
                                self.messages[index!] = message
                                self.tableVIew.reloadRows(at: [IndexPath(row: index!, section: 0)], with: .automatic)
                            }
                        }
                    }
                }
            }
            
            userStatusObserver = db.collection("users").document(otherUser.uid).addSnapshotListener({ documentSnapshot, err in
                if let err = err {
                    self.showAlert(with: err.localizedDescription)
                    return
                }
                
                if let documentSnapshot = documentSnapshot {
                    let otherUserData = documentSnapshot.data()
                    if otherUserData!["isOnline"] as! Bool {
                        self.userOnlineStatus.isHidden = false
                    } else {
                        self.userOnlineStatus.isHidden = true
                    }
                }
            })
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        IQKeyboardManager.shared.enable = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        msgObserver?.remove()
        userStatusObserver?.remove()
        
        navigationController?.isNavigationBarHidden = false
        IQKeyboardManager.shared.enable = true
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupControlls() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.otherProfilePic.layer.cornerRadius = otherProfilePic.bounds.height / 2
        
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {

        if let userInfo = notification.userInfo {

            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue

            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification

            bottomConstant?.constant = isKeyboardShowing ? keyboardFrame!.height - 30 : 0

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
                if self.messages.count > 0 {
                    self.tableVIew.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                }
                
            })
        }
    }
    
    func loadAllMessages() {
        ChatDBHelper.shared.getAllMessages(of: otherUser!.uid) { messages, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let messages = messages {
                self.messages.removeAll()
                self.messages = messages
                self.tableVIew.reloadData()
                if !messages.isEmpty {
                    self.tableVIew.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        if let text = messageText.text, text != "Enter Message" {
            if isMessageEditing {
                ChatDBHelper.shared.editMessage(mid: self.mid, with: text, time: self.time, to: otherUser!.uid, isLastMessage: isLastMessage)
                self.mid = ""
                self.isLastMessage = false
                self.time = nil
                self.isMessageEditing = false
            } else {
                ChatDBHelper.shared.sendMessage(with: text, to: otherUser!.uid, as: "text")
            }
            
            messageText.text = "Enter Message"
            messageText.textColor = UIColor.lightGray
            self.textViewHeight.constant = self.minHeight
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
            messageText.resignFirstResponder()
            
        } else {
            showAlert(with: "Enter Message")
        }
        
    }
    
    @IBAction func mediaButtonTapped(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    static func getDateString(from time: Timestamp) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(time.seconds))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(with message: String) {
        let avc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(avc, animated: true, completion: nil)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].senderID == currentUserID {
            
            if messages[indexPath.row].isDeletedForEveryone {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
                cell.msgText.text = "This message was deleted."
                cell.msgText.textColor = .gray
                cell.timeLbl.text = ChatViewController.getDateString(from: messages[indexPath.row].time)
                return cell
            } else if messages[indexPath.row].isDeletedForMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
                cell.msgText.text = "You deleted this message."
                cell.msgText.textColor = .gray
                cell.timeLbl.text = ChatViewController.getDateString(from: messages[indexPath.row].time)
                return cell
            } else {
                if messages[indexPath.row].type == "media" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MediaSenderCell") as! MediaSenderCell
                    cell.message = messages[indexPath.row]
                    
                    cell.videoPlayButtonTapped = {
                        if let url = URL(string: self.messages[indexPath.row].message) {
                            let player = AVPlayer(url: url)
                            let pvc = AVPlayerViewController()
                            pvc.player = player
                            self.present(pvc, animated: true, completion: nil)
                            player.play()
                        }
                    }
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
                    cell.msgText.textColor = .black
                    cell.msgText.text = messages[indexPath.row].message
                    cell.timeLbl.text = ChatViewController.getDateString(from: messages[indexPath.row].time)
                    return cell
                }
            }
        } else {
            
            if messages[indexPath.row].isDeletedForEveryone {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
                cell.msgText.text = "This message was deleted."
                cell.msgText.textColor = .gray
                cell.timeLbl.text = ChatViewController.getDateString(from: messages[indexPath.row].time)
                return cell
            } else if messages[indexPath.row].isDeletedForMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
                cell.msgText.text = "You deleted this message."
                cell.msgText.textColor = .gray
                cell.timeLbl.text = ChatViewController.getDateString(from: messages[indexPath.row].time)
                return cell
            } else {
                if messages[indexPath.row].type == "media" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MediaReceiverCell") as! MediaReceiverCell
                    cell.message = messages[indexPath.row]
                    
                    cell.videoPlayButtonTapped = {
                        if let url = URL(string: self.messages[indexPath.row].message) {
                            let player = AVPlayer(url: url)
                            let pvc = AVPlayerViewController()
                            pvc.player = player
                            self.present(pvc, animated: true, completion: nil)
                            player.play()
                        }
                    }
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
                    cell.msgText.textColor = .black
                    cell.msgText.text = messages[indexPath.row].message
                    cell.timeLbl.text = ChatViewController.getDateString(from: messages[indexPath.row].time)
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !messages[indexPath.row].isDeletedForMe && messages[indexPath.row].senderID == currentUserID {
            
            let vc = chatDemoStoryboard.instantiateViewController(withIdentifier: "MessageAlertViewController") as! MessageAlertViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            
            vc.editMessage = {
                self.isMessageEditing = true
                self.mid = self.messages[indexPath.row].mid
                self.time = self.messages[indexPath.row].time
                
                if indexPath.row == self.messages.count - 1 {
                    self.isLastMessage = true
                }
                
                self.messageText.text = self.messages[indexPath.row].message
                self.messageText.textColor = UIColor.black
            }
            
            vc.deleteForMe = {
                print("deleteForMe")
                ChatDBHelper.shared.deleteMessageForMe(with: self.messages[indexPath.row].mid, from: self.otherUser!.uid)
            }
            
            vc.deleteForEveryone = {
                print("deleteForEveryone")
                ChatDBHelper.shared.deleteMessageForEveryone(with: self.messages[indexPath.row].mid, from: self.otherUser!.uid)
            }
            
            present(vc, animated: true, completion: nil)
            
        }
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL {
            ChatDBHelper.shared.saveMediaMessage(with: url, to: otherUser!.uid)
        } else if let url = info[.mediaURL] as? URL {
            ChatDBHelper.shared.saveMediaMessage(with: url, to: otherUser!.uid)
        }
        
        dismiss(animated: true)
    }
    
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
            
        var height = self.minHeight
        
        if textView.contentSize.height <= self.minHeight {
            height = self.minHeight
        } else if textView.contentSize.height >= self.maxHeight {
            height = self.maxHeight
        } else {
            height = textView.contentSize.height
        }
        
        self.textViewHeight.constant = height
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
}
