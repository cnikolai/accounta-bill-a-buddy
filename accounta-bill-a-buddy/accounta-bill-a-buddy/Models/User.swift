//
//  User.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/16/21.
//

import Foundation

class User {
    
    let username: String
    let uid: String
    var friendRequestsFrom: [String]
    var friendRequestsTo: [String]
    
    init(username: String, uid: String, friendRequestsFrom: [String] = [], friendRequestsTo: [String] = []) {
        self.username = username
        self.uid = uid
        self.friendRequestsFrom = friendRequestsFrom
        self.friendRequestsTo = friendRequestsTo
    }
    
}//End of class

//MARK: - Extensions
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}//End of extension
