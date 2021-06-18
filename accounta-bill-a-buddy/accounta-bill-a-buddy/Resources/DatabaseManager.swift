//
//  DatabaseManager.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/18/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let sharedInstance = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func test() {
        database.child("foo").setValue(["something":true])
    }
    
    public func insertUser(with user: ChatAppUser) {
        
    }
    
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    //let profilePictureUrl: String
}
