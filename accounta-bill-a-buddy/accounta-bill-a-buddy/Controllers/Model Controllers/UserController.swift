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
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    for doc in querySnapshot!.documents {
                        print("documentID: \(doc.documentID) => \(doc.data())")
                        let userData = doc.data()
                        let username = userData["username"] as? String ?? ""
                        let uid = userData["uid"] as? String ?? ""
                        let user = User(username: username, uid: uid)
                        self.currentUser = user
                    }
                }
            }
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
//        let currentUserData = db.collection("users").document(currentUser.uid).collection("pendingRequests").document(currentUser.uid)
//        currentUserData.setData(["friendRequestsTo" : currentUser.friendRequestsTo])
//        
//        let currentUserData1 = db.collection("users").document(currentUser.uid).collection("pendingRequests").document(currentUser.uid)
//        currentUserData1.setData(["friendRequestsFrom" : currentUser.friendRequestsFrom])
//        
//        let userData = db.collection("users").document(user.uid).collection("pendingRequests").document(user.uid)
//        userData.setData(["friendRequestsTo" : user.friendRequestsTo])
//        
//        let userData1 = db.collection("users").document(user.uid).collection("pendingRequests").document(user.uid)
//        userData1.setData(["friendRequestsFrom" : user.friendRequestsFrom])
    
    }
    
    func filterDuplicateUsers(_ user: User) {
        users.forEach {
            if $0 != user, currentUser != user {
                users.append(user)
            }
            print($0.uid, user.uid)
        }
    }
    
}//End of class
