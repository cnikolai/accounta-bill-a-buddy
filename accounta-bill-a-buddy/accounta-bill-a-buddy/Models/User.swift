//
//  User.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/16/21.
//

import Foundation

class User {
    
    var username: String
    var uid: String
    var sentFriendRequests: [ [String : String] ]
    var receivedFriendRequests: [ [String : String] ]
    var userAdded: Bool?
    
    var _username: String {
        get {
            return username
        }
        set {
            username = newValue
        }
    }
    var _uid: String {
        get {
            return uid
        }
        set {
            uid = newValue
        }
    }
    var _sentFriendRequests: [ [String : String] ] {
        get {
            return sentFriendRequests
        }
        set {
            sentFriendRequests = newValue
        }
    }
    var _receivedFriendRequests: [ [String : String] ] {
        get {
            return receivedFriendRequests
        }
        set {
            receivedFriendRequests = newValue
        }
    }
    
    init(username: String, uid: String, sentFriendRequests: [ [String : String] ] = [ [:] ], receivedFriendRequests: [ [String : String] ] = [ [:] ], userAdded: Bool = false) {
        self.username = username
        self.uid = uid
        self.sentFriendRequests = sentFriendRequests
        self.receivedFriendRequests = receivedFriendRequests
        self.userAdded = userAdded
    }
    
}//End of class

//MARK: - Extensions
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}//End of extension
