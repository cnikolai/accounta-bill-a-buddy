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
    var friendRequestFromUser: User?
    var users = [User]()
    
    //MARK: - Firebase References
    let db = Firestore.firestore()
    
    //MARK: - User Sign Up
    func checkForDuplicateUsername(_ name: String, completion: @escaping((Bool) -> Void)) {
        db.collection("users").whereField("username", isEqualTo: name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    for doc in querySnapshot!.documents {
                        let userData = doc.data()
                        if userData.count > 0 {
                            completion(true)
                            return
                        }
                    }
                    completion(false)
                }
            }
    }
    
    //MARK: - Friend Request System
    func getCurrentUser(uid: String) {
        let user = User(uid: "", username: "", sentFriendRequests: [], receivedFriendRequests: [], friends: [])
        
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    for doc in querySnapshot!.documents {
//                        print("documentID: \(doc.documentID) => \(doc.data())")
                        let userData = doc.data()
                        let uid = userData["uid"] as? String ?? ""
                        let username = userData["username"] as? String ?? ""
                        let friends = userData["friends"] as? [ [String : String] ] ?? []
                        
                        user._uid = uid
                        user._username = username
                        user._friends = friends
                        
                        self.queryPendingRequestsCollection(with: user, and: uid)
                        
                        self.currentUser = user
                    }
                }
            }
    }
     
    func findUser(with name: String) {
        let user = User(uid: "", username: "", sentFriendRequests: [], receivedFriendRequests: [], friends: [])
        
        db.collection("users").whereField("username", isEqualTo: name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    (print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)"))
                } else {
                    for doc in querySnapshot!.documents {
                        //print("documentID: \(doc.documentID) => \(doc.data())")
                        let userData = doc.data()
                        let uid = userData["uid"] as? String ?? ""
                        let username = userData["username"] as? String ?? ""
                        let friends = userData["friends"] as? [ [String : String] ] ?? []
                        
                        user._uid = uid
                        user._username = username
                        user._friends = friends
                        
                        self.queryPendingRequestsCollection(with: user, and: uid)
                        
                        if self.users.count == 0, self.currentUser != user {
                            self.users.append(user)
                        } else {
                            self.filterDuplicateUsers(user)
                        }
                    }
                }
            }
    }
    
    func queryPendingRequestsCollection(with user: User, and uid: String) {
        db.collection("users").document(uid).collection("pendingRequests").document(uid)
            .getDocument { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let userData = querySnapshot?.data() {
                        let sentFriendRequests = userData["sentFriendRequests"] as? [ [String : String] ] ?? []
                        let receivedFriendRequests = userData["receivedFriendRequests"] as? [ [String : String] ] ?? []
                        
                        user._sentFriendRequests = sentFriendRequests
                        user._receivedFriendRequests = receivedFriendRequests
                    }
                }
            }
    }
    
    func pendingFriendRequestBetween(currentUser: User, user: User) {
        ///CURRENT USER - Saving sent friend request db
        saveSentFriendRequests(user: currentUser)
        
        ///USER - Saving received friend request to db
        saveReceivedFriendRequests(user: user)
    }
    
    func approveOrDenyFriendRequest(uid: String, username: String, action: String) {
        ///Remove user from current user's receivedFriendRequests array
        guard let currentUser = currentUser else { return }
        if let index = currentUser.receivedFriendRequests.firstIndex(where: { $0 == [uid : username] }) {
            currentUser.receivedFriendRequests.remove(at: index)
        }
        saveReceivedFriendRequests(user: self.currentUser!)
        
        ///Remove current user's uid from user's sentFriendRequests array
        var updateUserSentFriendRequests = [ [String : String] ]()
        db.collection("users").document(uid).collection("pendingRequests").document(uid)
            .getDocument(completion: { (snapshot, error)  in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                if let snapshot = snapshot {
                    guard let userData = snapshot.data() else { return }
                    let _sentFriendRequests = userData["sentFriendRequests"] as? [ [String : String] ] ?? []
                    updateUserSentFriendRequests = _sentFriendRequests
                }
            })
        
        if let index = updateUserSentFriendRequests.firstIndex(where: { $0 == [currentUser.uid : currentUser.username] }) {
            updateUserSentFriendRequests.remove(at: index)
        }
        
        let userData = db.collection("users").document(uid).collection("pendingRequests").document(uid)
        userData.setData(["sentFriendRequests" : updateUserSentFriendRequests], merge: true)
        userData.updateData(["sentFriendRequests" : FieldValue.arrayUnion(updateUserSentFriendRequests)])
        
        if action == "approve" {
            ///Add user to current user's friends array and save to db
            currentUser.friends.append([uid : username])
            let currentUserData = db.collection("users").document(currentUser.uid)
            currentUserData.setData(["friends": currentUser.friends], merge: true)
            
            ///Add current user to user's friends array and save to db
            db.collection("users").document(uid)
                .getDocument { (snapshot, error) in
                    if let error = error {
                        print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    } else {
                        if let snapshot = snapshot {
                            guard let userData = snapshot.data() else { return }
                            var friendsArray = userData["friends"] as? [ [String : String] ] ?? []
                            
                            self.db.collection("users").document(uid).setData(["friends" : friendsArray], merge: true)
                            friendsArray.append([currentUser.uid : currentUser.username])
                            
                            self.db.collection("users").document(uid).updateData(["friends" : FieldValue.arrayUnion(friendsArray)])
                        }
                    }
                }
        }
    }
    
    func saveSentFriendRequests(user: User) {
        var sentFriendRequests = user.sentFriendRequests
        
        db.collection("users").document(user.uid).collection("pendingRequests").document(user.uid)
            .getDocument(completion: { (snapshot, error)  in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                if let snapshot = snapshot {
                    guard let userData = snapshot.data() else { return }
                    let _sentFriendRequests = userData["sentFriendRequests"] as? [ [String : String] ] ?? []
                    sentFriendRequests = _sentFriendRequests
                }
            })
        
        let userData = db.collection("users").document(user.uid).collection("pendingRequests").document(user.uid)
        userData.setData(["sentFriendRequests" : sentFriendRequests], merge: true)
        userData.updateData(["sentFriendRequests" : FieldValue.arrayUnion(user.sentFriendRequests)])
    }
    
    func saveReceivedFriendRequests(user: User) {
        var receivedFriendRequests = user.receivedFriendRequests
        
        db.collection("users").document(user.uid).collection("pendingRequests").document(user.uid)
            .getDocument(completion: { (snapshot, error)  in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                if let snapshot = snapshot {
                    guard let userData = snapshot.data() else { return }
                    let _receivedFriendRequests = userData["receivedFriendRequests"] as? [ [String : String] ] ?? []
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
    
    func friendRequestSent(to uid: String, username: String) -> Bool {
        if let currentUser = currentUser {
            for user in currentUser.sentFriendRequests {
                if user == [uid : username] {
                    return true
                }
            }
        }
        return false
    }
    
    func receivedFriendRequest(from uid: String, username: String) -> Bool {
        if let currentUser = currentUser {
            for user in currentUser.receivedFriendRequests {
                if user == [uid : username] {
                    return true
                }
            }
        }
        return false
    }
    
    func friendsAlready(with uid: String, username: String) -> Bool {
        if let currentUser = currentUser {
            for user in currentUser.friends {
                if user == [uid : username] {
                    return true
                }
            }
        }
        return false
    }
    
}//End of class
