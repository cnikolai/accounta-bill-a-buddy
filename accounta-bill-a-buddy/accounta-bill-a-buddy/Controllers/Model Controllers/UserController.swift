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
    var users = [User]()
    
    //MARK: - Firebase References
    let db = Firestore.firestore()
    
    //MARK: - Friend Request System
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
                    
                        if self.users.count == 0 {
                            self.users.append(user)
                        } else {
                            self.filterDuplicateUsers(user)
                        }
                    }
                }
            }
    }
    
    func filterDuplicateUsers(_ user: User) {
        users.forEach {
            if $0 != user {
                users.append(user)
            }
            print($0.uid, user.uid)
        }
    }
    
    //MARK: - User Account
//    func createAccount(with email: String, password: String, username: String, completion: @escaping (_ success: Bool) -> Void) {
//        ///creates acc with email & password in Firebase auth
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//                completion(true)
//            } else {
//                ///stores username in Firestore db
//                self.db.collection("users").addDocument(data: ["username": username, "uid": result!.user.uid]) { (error) in
//                    if let error = error {
//                        print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//                    }
//                }
//                completion(false)
//            }
//        }
//    }
    
    
}//End of class
