//
//  User.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/16/21.
//

import Foundation

class User {
    
    var uid: String
    var username: String
    var sentFriendRequests: [ [String : String] ]
    var receivedFriendRequests: [ [String : String] ]
    var friends: [ [String : String] ]
    var blockedUsers: [String]
    var blockedByUsers: [String]

    var _uid: String {
        get {
            return uid
        }
        set {
            uid = newValue
        }
    }
    var _username: String {
        get {
            return username
        }
        set {
            username = newValue
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
    var _friends: [ [String : String] ] {
        get {
            return friends
        }
        set {
            friends = newValue
        }
    }
    var _blockedUsers: [String] {
        get {
            return blockedUsers
        }
        set {
            blockedUsers = newValue
        }
    }
    var _blockedByUsers: [String] {
        get {
            return blockedByUsers
        }
        set {
            return blockedByUsers = newValue
        }
    }
    
    init(uid: String, username: String, sentFriendRequests: [ [String : String] ] = [], receivedFriendRequests: [ [String : String] ] = [], friends: [ [String : String] ] = [], blockedUsers: [String] = [], blockedByUsers: [String] = []) {
        self.uid = uid
        self.username = username
        self.sentFriendRequests = sentFriendRequests
        self.receivedFriendRequests = receivedFriendRequests
        self.friends = friends
        self.blockedUsers = blockedUsers
        self.blockedByUsers = blockedByUsers
    }
    
}//End of class

//MARK: - Extensions
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}//End of extension
