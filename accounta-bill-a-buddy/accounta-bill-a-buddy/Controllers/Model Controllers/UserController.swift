//
//  UserController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/16/21.
//

import Foundation
import FirebaseFirestore

class UserController {
    
    //MARK: - Singleton/Shared Instance
    static let sharedInstance = UserController()
    
    //MARK: - SOT
    var currentUser: User?
    var users = [User]()
    
    //MARK: - Firebase References
    let db = Firestore.firestore()
    
    //MARK: - Friend Request System
    func getCurrentUser(uid: String) {
        let user = User(username: "", uid: "", sentFriendRequests: [], receivedFriendRequests: [])
        
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    for doc in querySnapshot!.documents {
                        print("documentID: \(doc.documentID) => \(doc.data())")
                        let userData = doc.data()
                        let username = userData["username"] as? String
                        let uid = userData["uid"] as? String
                        
                        user._username = username!
                        user._uid = uid!
                    }
                }
            }
        
        db.collection("users").document(uid).collection("pendingRequests").document(uid)
            .getDocument { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let userData = querySnapshot?.data() {
                        let sentFriendRequests = userData["sentFriendRequests"] as? [String]
                        let receivedFriendRequests = userData["receivedFriendRequests"] as? [String]
                        
                        user._sentFriendRequests = sentFriendRequests!
                        user._receivedFriendRequests = receivedFriendRequests!
                    }
                }
            }
        
        self.currentUser = user
    }
    
    func findUserWith(_ name: String) {
        db.collection("users").whereField("username", isEqualTo: name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    (print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)"))
                } else {
                    for doc in querySnapshot!.documents {
                        print("documentID: \(doc.documentID) => \(doc.data())")
                        let userData = doc.data()
                        let username = userData["username"] as? String ?? ""
                        let uid = userData["uid"] as? String ?? ""
                        let user = User(username: username, uid: uid)
                    
                        if self.users.count == 0, self.currentUser != user {
                            self.users.append(user)
                        } else {
                            self.filterDuplicateUsers(user)
                        }
                    }
                }
            }
    }
    
    func pendingFriendRequestBetween(currentUser: User, user: User) {
        var sentFriendRequests = currentUser.sentFriendRequests
        
        let _ = db.collection("users").document(currentUser.uid).collection("pendingRequests").document(currentUser.uid)
            .getDocument(completion: { (snapshot, error)  in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                if let snapshot = snapshot {
                    guard let userData = snapshot.data() else { return }
                    let _sentFriendRequests = userData["sentFriendRequests"] as? [String] ?? []
                    sentFriendRequests = _sentFriendRequests
                }
        })

        let currentUserData = db.collection("users").document(currentUser.uid).collection("pendingRequests").document(currentUser.uid)
        currentUserData.setData(["sentFriendRequests" : sentFriendRequests], merge: true)
        currentUserData.updateData(["sentFriendRequests" : FieldValue.arrayUnion(currentUser.sentFriendRequests)])
        
        var receivedFriendRequests = user.receivedFriendRequests
        let _ = db.collection("users").document(user.uid).collection("pendingRequests").document(user.uid)
            .getDocument(completion: { (snapshot, error)  in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                if let snapshot = snapshot {
                    guard let userData = snapshot.data() else { return }
                    let _receivedFriendRequests = userData["receivedFriendRequests"] as? [String] ?? []
                    receivedFriendRequests = _receivedFriendRequests
                }
        })
            
        let userData = db.collection("users").document(user.uid).collection("pendingRequests").document(user.uid)
        userData.setData(["receivedFriendRequests" : receivedFriendRequests], merge: true)
        userData.updateData(["receivedFriendRequests" : FieldValue.arrayUnion(user.receivedFriendRequests)])
    }
    
    func filterDuplicateUsers(_ user: User) {
        users.forEach {
            if $0 != user, currentUser != user {
                users.append(user)
            }
            print($0.uid, user.uid)
        }
    }
    
    func filterDuplicateRequests(_ uid: String, from array: [String]) {
//        array.forEach {
//            if $0 == uid {
//
//            }
//        
//        return newArray
//        }
    }
    
}//End of class
