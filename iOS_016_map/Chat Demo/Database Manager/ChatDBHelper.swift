//
//  ChatDBHelper.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 14/05/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ChatDBHelper {
    
    static var shared = ChatDBHelper()
    
    var db = Firestore.firestore()
    
    func getAllUser(completion: @escaping (([NewChatUser]?, Error?) -> ())) {
        
        let userRef = db.collection("users")
        
        userRef.whereField("uid", isNotEqualTo: currentUserID).getDocuments { snapshot, err in
            if let err = err {
                completion(nil, err)
                return
            }
            
            var newChatUserList = [NewChatUser]()
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    newChatUserList.append(NewChatUser(data: document.data())!)
                }
                completion(newChatUserList, nil)
            }
        }
        
    }
    
    func getConnectedUser(completion: @escaping (([ChatUser]?, Error?) -> ())) {
        
        let userRef = db.collection("users")
        
        userRef.document(currentUserID).collection("chat").getDocuments { snapshot, err in
            if let err = err {
                print(err)
                return
            }
            
            var documentID = [String]()
            var connectedUserList = [ChatUser]()
            
            if let snapshot = snapshot {
                
                if snapshot.documents.isEmpty {
                    completion(connectedUserList, nil)
                    return
                }
                
                for document in snapshot.documents {
                    documentID.append(document.documentID)
                    
                    userRef.whereField("uid", isEqualTo: document.documentID).getDocuments { userDocument, err in
                        if let err = err {
                            completion(nil, err)
                            return
                        }
                        
                        if let userDocument = userDocument {
                            for userData in userDocument.documents {
                                
                                var user = userData.data()
                                user["last_message"] = document.data()["last_message"]
                                user["time"] = document.data()["time"]

                                connectedUserList.append(ChatUser(data: user)!)
                            }
                            completion(connectedUserList, nil)
                        }
                    }
                }
                
            }
        }
        
    }
    
    func createNewChatRoom(with userID: String) {
        
        let chatRef = db.collection("users").document(currentUserID).collection("chat")
        chatRef.document(userID).setData(["last_message": "", "time": Timestamp(date: Date.now)])
        
        let receiverChatRef = db.collection("users").document(userID).collection("chat")
        receiverChatRef.document(currentUserID).setData(["last_message": "", "time": Timestamp(date: Date.now)])
    }
    
    func sendMessage(with message: String, to otherUserID: String, as type: String) {
        let msgRef = db.collection("users").document(currentUserID).collection("chat").document(otherUserID).collection("messages")
        let receiverMsgRef = db.collection("users").document(otherUserID).collection("chat").document(currentUserID).collection("messages")
        
        let mid = msgRef.document()
        
        let msg = Message(mid: mid.documentID,
                              message: message,
                              type: type,
                              time: Timestamp(date: Date.now),
                              senderID: currentUserID,
                              receiverID: otherUserID,
                              isDeletedForMe: false,
                              isDeletedForEveryone: false)
        
        do {
            try msgRef.document(mid.documentID).setData(from: msg)
            try receiverMsgRef.document(mid.documentID).setData(from: msg)
            
            db.collection("users").document(currentUserID).collection("chat").document(otherUserID).setData([
                "last_message": message,
                "time": Timestamp(date: Date.now)
            ])
            db.collection("users").document(otherUserID).collection("chat").document(currentUserID).setData([
                "last_message": message,
                "time": Timestamp(date: Date.now)
            ])
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func editMessage(mid : String, with message: String, time: Timestamp, to otherUserID: String, isLastMessage: Bool) {
        let msgRef = db.collection("users").document(currentUserID).collection("chat").document(otherUserID).collection("messages")
        let receiverMsgRef = db.collection("users").document(otherUserID).collection("chat").document(currentUserID).collection("messages")
        
        let msg = Message(mid: mid,
                              message: message,
                              type: "text",
                              time: time,
                              senderID: currentUserID,
                              receiverID: otherUserID,
                              isDeletedForMe: false,
                              isDeletedForEveryone: false)
        
        do {
            try msgRef.document(mid).setData(from: msg)
            try receiverMsgRef.document(mid).setData(from: msg)
            
            if isLastMessage {
                db.collection("users").document(currentUserID).collection("chat").document(otherUserID).setData([
                    "last_message": message,
                    "time": Timestamp(date: Date.now)
                ])
                db.collection("users").document(otherUserID).collection("chat").document(currentUserID).setData([
                    "last_message": message,
                    "time": Timestamp(date: Date.now)
                ])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveMediaMessage(with url: URL, to otherUserID: String) {
        let imgExtension = url.pathExtension
        let storageRef = Storage.storage().reference().child("chatMedia/\(UUID().uuidString).\(imgExtension)")
        
        var mediaTask: StorageUploadTask!
        do {
            let data = try Data(contentsOf: url)
            mediaTask = storageRef.putData(data, metadata: nil)
        } catch {
            print(error.localizedDescription)
            return
        }
        //let mediaTask = storageRef.putFile(from: url, metadata: nil)
        
        let msgRef = db.collection("users").document(currentUserID).collection("chat").document(otherUserID).collection("messages")
        let receiverMsgRef = db.collection("users").document(otherUserID).collection("chat").document(currentUserID).collection("messages")
        
        let mid = msgRef.document()
        
        var msg = Message(mid: mid.documentID,
                          message: "\(url)",
                          type: "media",
                          time: Timestamp(date: Date.now),
                          senderID: currentUserID,
                          receiverID: otherUserID,
                          isDeletedForMe: false,
                          isDeletedForEveryone: false)
        
        do {
            try msgRef.document(mid.documentID).setData(from: msg)
            self.db.collection("users").document(currentUserID).collection("chat").document(otherUserID).setData([
                "last_message": "Media File",
                "time": Timestamp(date: Date.now)
            ])
        } catch {
            print(error.localizedDescription)
        }
        
        print(mediaTask.snapshot.status)
        mediaTask.observe(.success) { snapshot in
            
            storageRef.downloadURL { fileURL, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                if let fileURL = fileURL {
                    do {
                        msg?.message = "\(fileURL)"
                        try msgRef.document(mid.documentID).setData(from: msg)
                        try receiverMsgRef.document(mid.documentID).setData(from: msg)
                        self.db.collection("users").document(otherUserID).collection("chat").document(currentUserID).setData([
                            "last_message": "Media File",
                            "time": Timestamp(date: Date.now)
                        ])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            
        }
    }
    
    func deleteMessageForMe(with mid: String, from otherUserID: String) {
        
        let msgRef = db.collection("users").document(currentUserID).collection("chat").document(otherUserID).collection("messages")
        
        msgRef.document(mid).updateData([
            "isDeletedForMe": true
        ])
        
    }
    
    func deleteMessageForEveryone(with mid:String, from otherUserID: String) {
        let msgRef = db.collection("users").document(currentUserID).collection("chat").document(otherUserID).collection("messages")
        let receiverMsgRef = db.collection("users").document(otherUserID).collection("chat").document(currentUserID).collection("messages")
        
        msgRef.document(mid).updateData([
            "isDeletedForMe": true,
            "isDeletedForEveryone": true
        ])
        
        receiverMsgRef.document(mid).updateData([
            "isDeletedForMe": true,
            "isDeletedForEveryone": true
        ])
    }
    
    func getAllMessages(of otherUserID: String, completion: @escaping (([Message]?, Error?) -> ())) {
        
        let msgRef = db.collection("users").document(currentUserID).collection("chat").document(otherUserID).collection("messages")
        
        msgRef.order(by: "time").getDocuments { snapshots, err in
            if let err = err {
                completion(nil, err)
                return
            }
            
            var messages = [Message]()
            
            if let snapshots = snapshots {
                for snapshot in snapshots.documents {
                    messages.append(Message(data: snapshot.data())!)
                }
                completion(messages, nil)
            }
        }
        
    }
    
}
