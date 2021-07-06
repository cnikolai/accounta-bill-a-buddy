//
//  Wager.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/24/21.
//

import Foundation
import Firebase

class Wager {
    var wagerID: String
    //holds the uuid of the owner
    var owner: String
    
    //stores the uid of friends
    var invitedFriends: [String]
    var acceptedFriends: [String]
    
    var goalDescription: String
    var wager: String
    var deadline: String
    var progress: Float
    var wagerPhotoData: Data?
    
    var wagerPhoto: UIImage? {
        get {
            guard let data = wagerPhotoData else {return nil}
            return UIImage(data: data)
        } set {
            wagerPhotoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(wagerID: String = UUID().uuidString, owner: String, invitedFriends: [String], acceptedFriends: [String], goalDescription: String, wager: String, deadline: String, progress: Float, wagerPhoto: UIImage? = #imageLiteral(resourceName: "wagerDefaultPhoto")) {
        self.wagerID = wagerID
        self.owner = owner
        self.invitedFriends = invitedFriends
        self.acceptedFriends = acceptedFriends
        self.goalDescription = goalDescription
        self.wager = wager
        self.deadline = deadline
        self.progress = progress
        self.wagerPhoto = wagerPhoto
    }
    
    convenience init?(document: DocumentSnapshot) {
        guard let wagerID = document["wagerID"] as? String,
              let owner = document["owner"] as? String,
              let goalDescription = document["goalDescription"] as? String,
              let wager = document["wager"] as? String,
              let invitedFriends = document["invitedFriends"] as? [String],
              let acceptedFriends = document["acceptedFriends"] as? [String],
              let deadline = document["deadline"] as? String,
              let progress = document["progress"] as? Float else { return nil }
    
        var wagerPhoto: UIImage?
        
        if let wagerPhotoData = document["wagerPhoto"] as? Data {
            wagerPhoto = UIImage(data: wagerPhotoData)
        }
        
        self.init(wagerID: wagerID, owner: owner, invitedFriends: invitedFriends, acceptedFriends: acceptedFriends, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress, wagerPhoto: wagerPhoto)
    }
    
    func savePhoto(wager: Wager, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        //let storage = Storage.storage()
        
        //let wagerPhotoData = wagerPhoto.jpegData(compressionQuality: 0.5)

        
    }
}//End of class

//MARK: - Extensions
extension Wager: Equatable {
    static func == (lhs: Wager, rhs: Wager) -> Bool {
        print("lhs.wagerID", lhs.wagerID, "rhs.wagerID", rhs.wagerID)
        return lhs.wagerID == rhs.wagerID
    }
}//End of extension
