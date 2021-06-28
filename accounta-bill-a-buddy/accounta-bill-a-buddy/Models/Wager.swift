//
//  Wager.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/24/21.
//

import Foundation
import Firebase

class Wager {
    var uuid: String
    var owner: String
    var acceptedWagers: [Wager]
    var pendingWagers: [Wager]
    // a list of other people who are able to see/comment on the wager
    var wagerBuddies: [String]
    var wagerPhoto: UIImage? {
        get {
            guard let data = wagerPhotoData else {return nil}
            return UIImage(data: data)
        } set {
            wagerPhotoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var wagerPhotoData: Data?
    var goalDescription: String
    var wager: String
    var deadline: String
    var progress: Float
    
    init(owner: String, wagerBuddies: [String], wagerPhoto: UIImage? = #imageLiteral(resourceName: "wagerDefaultPhoto"), goalDescription: String, wager: String, deadline: String, progress: Float, uuid: String = UUID().uuidString, acceptedWagers: [Wager] = [], pendingWagers: [Wager] = []) {
        self.owner = owner
        self.wagerBuddies = wagerBuddies
        self.goalDescription = goalDescription
        self.wager = wager
        self.deadline = deadline
        self.progress = progress
        self.uuid = uuid
        self.acceptedWagers = acceptedWagers
        self.pendingWagers = pendingWagers
        self.wagerPhoto = wagerPhoto

    }
    
    convenience init?(document: DocumentSnapshot) {
        guard let owner = document["owner"] as? String,
              let wagerBuddies = document["wagerBuddies"] as? [String],
              let goalDescription = document["goalDescription"] as? String,
              let wager = document["wager"] as? String,
              let deadline = document["deadline"] as? String,
              let progress = document["progress"] as? Float,
              let acceptedWagers = document["acceptedWagers"] as? [Wager],
              let pendingWagers = document["pendingWagers"] as? [Wager] else { return nil }
        
        
        var wagerPhoto: UIImage?
        
        if let wagerPhotoData = document["wagerPhoto"] as? Data {
            wagerPhoto = UIImage(data: wagerPhotoData)
        }
        
        self.init(owner: owner, wagerBuddies: wagerBuddies, wagerPhoto: wagerPhoto, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress, uuid: document.documentID, acceptedWagers: acceptedWagers, pendingWagers: pendingWagers)
    }
}

extension Wager: Equatable {
    static func == (lhs: Wager, rhs: Wager) -> Bool {
        print("lhs.uuid", lhs.uuid)
        print("rhs.uuid", rhs.uuid)
        return lhs.uuid == rhs.uuid 
    }
    
    
    
    
}
