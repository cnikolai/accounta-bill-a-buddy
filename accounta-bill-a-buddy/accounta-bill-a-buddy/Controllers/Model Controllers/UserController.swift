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
    func sendRequestToUser(_ userID: String) {
        
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
