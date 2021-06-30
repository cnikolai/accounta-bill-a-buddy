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
    ///CURRENT USER DATA
    func getCurrentUser(uid: String) {
        let user = User(uid: "", username: "", sentFriendRequests: [], receivedFriendRequests: [], friends: [], blockedUsers: [], blockedByUsers: [])
        
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    for doc in querySnapshot!.documents {
                        //print("documentID: \(doc.documentID) => \(doc.data())")
                        let userData = doc.data()
                        let uid = userData["uid"] as? String ?? ""
                        let username = userData["username"] as? String ?? ""
                        let friends = userData["friends"] as? [ [String : String] ] ?? []
                        let blockedUsers = userData["blockedUsers"] as? [String] ?? []
                        let blockedByUsers = userData["blockedByUsers"] as? [String] ?? []
                        
                        user._uid = uid
                        user._username = username
                        user._friends = friends
                        user._blockedUsers = blockedUsers
                        user._blockedByUsers = blockedByUsers
                        
                        self.fetchPendingRequestsCollection(for: user, with: uid)
                        
                        self.currentUser = user
                    }
                }
            }
    }
    ///FIND FRIENDS
    func findUser(with name: String) {
        let user = User(uid: "", username: "", sentFriendRequests: [], receivedFriendRequests: [], friends: [])
        
        let userBlocked = checkIfUserIsBlocked(username: name)
        let blockedByUser = checkIfBlockedByUser(username: name)
        
        if !userBlocked && !blockedByUser {
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
                            
                            self.fetchPendingRequestsCollection(for: user, with: uid)
                            
                            if self.users.count == 0, self.currentUser != user {
                                self.users.append(user)
                            } else {
                                self.filterDuplicateUsers(user)
                            }
                        }
                    }
                }
        }
    }
    func fetchPendingRequestsCollection(for user: User, with uid: String) {
        ///Grabs pending request data for current user and user that was searched for
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
    
    ///FRIEND REQUESTS
    func pendingFriendRequestBetween(currentUser: User, user: User) {
        ///Current User - Saves sent friend requests db
        saveSentFriendRequests(user: currentUser)
        
        ///User - Saves received friend requests to db
        saveReceivedFriendRequests(user: user)
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
    
    ///FRIENDS LIST
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
            
            ///Fetch user's friends array and add current user to the user's friends array, then update friends array and save to db
            db.collection("users").document(uid)
                .getDocument { (snapshot, error) in
                    if let error = error {
                        print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    } else {
                        if let snapshot = snapshot {
                            guard let userData = snapshot.data() else { return }
                            var friendsArray = userData["friends"] as? [ [String : String] ] ?? []
                            
                            ///Additional read to write to the current state of the user's friends array
                            self.db.collection("users").document(uid).setData(["friends" : friendsArray], merge: true)
                            friendsArray.append([currentUser.uid : currentUser.username])
                            
                            self.db.collection("users").document(uid).updateData(["friends" : FieldValue.arrayUnion(friendsArray)])
                        }
                    }
                }
        }
    }
    
    ///DELETE FRIEND
    func deleteFriend(uid: String, username: String) {
        ///Remove friend from current user's friends array and save to db
        guard let currentUser = currentUser else { return }
        if let index = currentUser.friends.firstIndex(where: { $0 == [uid : username] }) {
            currentUser.friends.remove(at: index)
        }
        
        let currentUserData = db.collection("users").document(currentUser.uid)
        currentUserData.setData(["friends": currentUser.friends], merge: true)
        
        ///Fetch user's friends array and remove current user from the friends array, then update the friends array and save to db
        db.collection("users").document(uid)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let snapshot = snapshot {
                        guard let userData = snapshot.data() else { return }
                        var friendsArray = userData["friends"] as? [ [String : String] ] ?? []
                        
                        if let index = friendsArray.firstIndex(where: { $0 == [currentUser.uid : currentUser.username]}) {
                            friendsArray.remove(at: index)
                        }
                        
                        ///Additional read to write to the current state of the user's friends array
                        self.db.collection("users").document(uid).setData(["friends" : friendsArray], merge: true)
                        self.db.collection("users").document(uid).updateData(["friends" : FieldValue.arrayUnion(friendsArray)])
                    }
                }
            }
    }
    
    ///BLOCK FRIEND
    func blockFriend(uid: String, username: String) {
        deleteFriend(uid: uid, username: username)
        
        guard let currentUser = currentUser else { return }
        currentUser.blockedUsers.append(username)
        
        let currentUserData = db.collection("users").document(currentUser.uid)
        currentUserData.setData(["blockedUsers": currentUser.blockedUsers], merge: true)
        
        ///Fetch user's blockedByUsers array and add current user to the blockedByUsers array, then update blockedByUsers array and save to db
        db.collection("users").document(uid)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let snapshot = snapshot {
                        guard let userData = snapshot.data() else { return }
                        var blockedByUsers = userData["blockedByUsers"] as? [String] ?? []
                        
                        ///Additional read to write to the current state of the user's friends array
                        self.db.collection("users").document(uid).setData(["blockedByUsers" : blockedByUsers], merge: true)
                        blockedByUsers.append(currentUser.username)
                        
                        self.db.collection("users").document(uid).updateData(["blockedByUsers" : FieldValue.arrayUnion(blockedByUsers)])
                    }
                }
            }
        
    }
    
    ///REPORT FRIEND
    func reportFriend(uid: String, username: String) {
        blockFriend(uid: uid, username: username)
        
        guard let currentUser = currentUser else { return }
        currentUser.reportedUsers.append([uid : username])
        
        let currentUserData = db.collection("users").document(currentUser.uid)
        currentUserData.setData(["reportedUsers": currentUser.reportedUsers], merge: true)
    }
    //reported users array (add a listener for notifications)
    //auth email
    
    //MARK: - Utility/Filter-type Functions
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
    
    func checkIfUserIsBlocked(username: String) -> Bool {
        if let currentUser = currentUser {
            for name in currentUser.blockedUsers {
                if name == username {
                    return true
                }
            }
        }
        return false
    }
    
    func checkIfBlockedByUser(username: String) -> Bool {
        if let currentUser = currentUser {
            for name in currentUser.blockedByUsers {
                if name == username {
                    return true
                }
            }
        }
        return false
    }
    
    //MARK: - Fetch Wagers
//    func fetchAllWagersWithOwner(completion: @escaping (Result<[Wager], DatabaseError>) -> Void) {
//        guard let currentUser = currentUser else { return completion(.failure(DatabaseError.couldNotUnwrap)) }
//        return completion(.success(currentUser.myWagers))
//    }
//    
//    func fetchWagersWithFriends(completion: @escaping (Result<[Wager], DatabaseError>) -> Void) {
//        guard let currentUser = currentUser else { return completion(.failure(DatabaseError.couldNotUnwrap)) }
//        return completion(.success(currentUser.myFriendsWagers))
//    }
//    
//    func fetchPendingWagers(completion: @escaping (Result<[Wager], DatabaseError>) -> Void) {
//        guard let currentUser = currentUser else { return completion(.failure(DatabaseError.couldNotUnwrap)) }
//        return completion(.success(currentUser.wagerRequests))
//    }
    
}//End of class
