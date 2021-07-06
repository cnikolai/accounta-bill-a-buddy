//
//  User.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/16/21.
//

import Foundation

class User {
    
    ///Friend Request System Properties
    var uid: String
    var username: String
    var sentFriendRequests: [ [String : String] ]
    var receivedFriendRequests: [ [String : String] ]
    //uuid:username
    var friends: [ [String : String] ]
    var blockedUsers: [ [String : String] ]
    var blockedByUsers: [ [String : String] ]
    var reportedUsers: [ [String : String] ]
    
    ///Wagers Properties
    //An array of wager ids that reference an object in the wagers top-level collection that were created by the current user
    var myWagers: [String]
    //An array of wager ids that reference an object in the wagers top-level collection that the current user accepted and is part of
    var myFriendsWagers: [String]
    //An array of wager ids that reference an object in the wagers top-level collection that need to be accepted or denied by the current user
    var wagerRequests: [String]
    
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
    var _blockedUsers: [ [String : String] ] {
        get {
            return blockedUsers
        }
        set {
            blockedUsers = newValue
        }
    }
    var _blockedByUsers: [ [String : String] ] {
        get {
            return blockedByUsers
        }
        set {
            return blockedByUsers = newValue
        }
    }
    var _reportedUsers: [ [String : String] ] {
        get {
            return reportedUsers
        }
        set {
            return reportedUsers = newValue
        }
    }
    
    var _myWagers: [String] {
        get {
            return myWagers
        }
        set {
            myWagers = newValue
        }
    }
    
    var _myFriendsWagers: [String] {
        get {
            return myFriendsWagers
        }
        set {
            myFriendsWagers = newValue
        }
    }
    
    var _wagerRequests: [String] {
        get {
            return wagerRequests
        }
        set {
            wagerRequests = newValue
        }
    }
    
    init(uid: String, username: String, sentFriendRequests: [ [String : String] ] = [], receivedFriendRequests: [ [String : String] ] = [], friends: [ [String : String] ] = [], blockedUsers: [ [String : String] ] = [], blockedByUsers: [ [String : String] ] = [], reportedUsers: [ [String : String] ] = [], myWagers: [String] = [], myFriendsWagers: [String] = [], wagerRequests: [String] = []) {
        self.uid = uid
        self.username = username
        self.sentFriendRequests = sentFriendRequests
        self.receivedFriendRequests = receivedFriendRequests
        self.friends = friends
        self.blockedUsers = blockedUsers
        self.blockedByUsers = blockedByUsers
        self.reportedUsers = reportedUsers
        self.myWagers = myWagers
        self.myFriendsWagers = myFriendsWagers
        self.wagerRequests = wagerRequests
    }
}//End of class

//MARK: - Extensions
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}//End of extension
