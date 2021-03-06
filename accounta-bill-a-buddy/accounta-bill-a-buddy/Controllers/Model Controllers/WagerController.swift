//
//  WagerController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/24/21.
//

import Foundation
import FirebaseFirestore

class WagerController {
    
    static let sharedInstance = WagerController()
    let db = Firestore.firestore()
    let wagersCollection = "wagers"
    var wagers: [Wager] = []
    
    func createAndSaveWager(wagerID: String, owner: String, invitedFriends: [String], acceptedFriends: [String], goalDescription: String, wager: String, deadline: String, progress: Float, wagerPhoto: UIImage?, completion: @escaping (Result<Wager, DatabaseError>) -> Void) {
        
        let newWager = Wager(wagerID: wagerID, owner: owner, invitedFriends: invitedFriends, acceptedFriends: acceptedFriends, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress,wagerPhoto: wagerPhoto)
        
        let wagersRef = db.collection(wagersCollection)
        wagersRef.document("\(newWager.wagerID)").setData([
            "wagerID": newWager.wagerID,
            "owner": newWager.owner,
            "wagerPhoto": newWager.wagerPhoto?.jpegData(compressionQuality: 1),
            "goalDescription": newWager.goalDescription,
            "acceptedFriends": newWager.acceptedFriends,
            "invitedFriends": newWager.invitedFriends,
            "wager": newWager.wager,
            "deadline": newWager.deadline,
            "progress": newWager.progress
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                print("Wager Document added with ID: \(newWager.wagerID)")
                return completion(.success(newWager))
            }
        }
    }
    
    func fetchWager(wagerID: String, completion: @escaping (Result<Wager, DatabaseError>) -> Void) {
        db.collection("wagers").whereField("wagerID", isEqualTo: wagerID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Wager document does not exist.")
                    return completion(.failure(.fireError(error)))
                } else {
                    for doc in querySnapshot!.documents {
                        let wagerData = doc.data()
                        let wagerID = wagerData["wagerID"] as? String ?? ""
                        let owner = wagerData["owner"] as? String ?? ""
                        let goalDescription = wagerData["goalDescription"] as? String ?? ""
                        let wager = wagerData["wager"] as? String ?? ""
                        let wagerPhotoData = wagerData["wagerPhoto"] as? Data ?? Data()
                        let invitedFriends = wagerData["invitedFriends"] as? [String] ?? []
                        let acceptedFriends = wagerData["acceptedFriends"] as? [String] ?? []
                        let deadline = wagerData["deadline"] as? String ?? ""
                        let progress = wagerData["progress"] as? Float ?? 0.0
                        
                        let image = UIImage(data: wagerPhotoData)
                        let newWager = Wager(wagerID: wagerID, owner: owner, invitedFriends: invitedFriends, acceptedFriends: acceptedFriends, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress, wagerPhoto: image)
                        return(completion(.success(newWager)))
                    }
                }
            }
    }
    
    func createWagerArray(wagerStrings: [String], completion: @escaping (Result<[Wager], Error>) -> Void) {
        let group = DispatchGroup()
        var myWagers: [Wager] = []
        var errors: [Error] = []
        
        for wager in wagerStrings {
            group.enter()
            fetchWager(wagerID: wager) { result in
                switch result {
                case .success(let wager):
                    myWagers.append(wager)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .global()) {
            // NOTE: Returns the first error but probably should return them all
            if let error = errors.first {
                completion(.failure(error))
            }
            completion(.success(myWagers))
        }
    }
    
    ///ACCEPT/DECLINE Wagers
    func removeWagerFromMyPendingWagers(wagerId: String) {
        //remove wager from my(currentuser) wager requests
        guard let indexofWagerToBeRemvoed = UserController.sharedInstance.currentUser?._wagerRequests.firstIndex(of: wagerId) else { return }
        UserController.sharedInstance.currentUser?._wagerRequests.remove(at: indexofWagerToBeRemvoed)
        //save currentuser mywagers to database
        UserController.sharedInstance.updateMyWagerRequestsList()
        //UserController.sharedInstance.currentUser?.myFriendsWagers.append(wagerId)
        //UserController.sharedInstance.updateMyFriendsWagersList()
        
    }
    
    func addWagerToMyFriendsWagers(wager: Wager) {
        UserController.sharedInstance.currentUser?.myFriendsWagers.append(wager.wagerID)
        UserController.sharedInstance.updateMyFriendsWagersList()
        //UserController.sharedInstance.updateMyFriendsWagersList(with: wager)
    }
    
    func removeCurrentUserFromWagersInvitedFriendsList(wager: Wager) {
        guard let indexofCurrentUserasInvitedFriendofWager = wager.invitedFriends.firstIndex(of: UserController.sharedInstance.currentUser!._uid) else {
            print("inside indexofcurrentuserasinvitedfrinewofwager")
            return
        }
        print("index of currentusertoberemoved from friends list: ",indexofCurrentUserasInvitedFriendofWager)
        
        wager.invitedFriends.remove(at: indexofCurrentUserasInvitedFriendofWager)
        updateWagerInvitedFriends(wagerId: wager.wagerID, invitedFriends: wager.invitedFriends)
    }
    
    func updateWagerAcceptedFriends(wagerId: String, acceptedFriends: [String]) {
        let wagersRef = db.collection(wagersCollection).document(wagerId)
        wagersRef.updateData([
            "acceptedFriends": acceptedFriends
        ]) { err in
            if let err = err {
                print("Error updating accepted friends for wager document: \(err)")
            } else {
                print("Accepted friends for wager Document successfully updated")
            }
        }
    }
    
    func updateWagerInvitedFriends(wagerId: String, invitedFriends: [String]) {
        let wagersRef = db.collection(wagersCollection).document(wagerId)
        wagersRef.updateData([
            "invitedFriends": invitedFriends
        ]) { err in
            if let err = err {
                print("Error updating invited friends for wager document: \(err)")
            } else {
                print("Invited friends for wager Document successfully updated")
            }
        }
    }
  
    func updateWager(wager: Wager) {
        let wagersRef = db.collection(wagersCollection).document(wager.wagerID)
        wagersRef.updateData([
            "goalDescription": wager.goalDescription,
            "wager": wager.wager,
            "deadline": wager.deadline,
            "progress": wager.progress
        ]) { err in
            if let err = err {
                print("Error updating wager: \(err)")
            } else {
                print("Wager successfully updated")
            }
        }       
    }
  
     ///DELETE WAGER
    //TIFFSAKA - Added completions on two of the delete functions while testing. May not need these. If needed, will need to add to the additonal two delete functions.
    //Delete Wager from Wagers collection
    func deleteWager(wagerID: String, completion: ((Bool) -> Void)?) {
        let wagersRef = db.collection(wagersCollection).document(wagerID)
        wagersRef.delete() { error in
            if let error = error {
                print("Error removing wager document: \(error)")
            } else {
                print("Successfully deleted wager with id: \(wagerID)")
                completion?(true)
            }
        }
    }
    
    //Delete wager from myWagers array in Users collection
    func deleteWagerFromMyWagers(wagerToDelete: Wager, completion: ((Bool) -> Void)?) {
        guard let currentUser = UserController.sharedInstance.currentUser else { return }

        self.db.collection("users").document(currentUser.uid)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let data = snapshot?.data() {
                        var myWagers = data["myWagers"] as? [String] ?? []
                        
                        if let index = myWagers.firstIndex(of: wagerToDelete.wagerID) {
                            myWagers.remove(at: index)
                        }
                        
                        let currentUserData = self.db.collection("users").document(currentUser.uid)
                        currentUserData.setData(["myWagers": myWagers], merge: true)
                        completion?(true)
                    }
                }
            }
    }
    
    //Delete wager from friend's myFriendsWagers array in Users collection
    func deleteWagerFromMyFriendsWagers(wagerToDelete: Wager) {
        for friend in wagerToDelete.acceptedFriends {
            self.db.collection("users").document(friend)
                .getDocument { (snapshot, error) in
                    if let error = error {
                        print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    } else {
                        if let data = snapshot?.data() {
                            var myFriendsWagers = data["myFriendsWagers"] as? [String] ?? []
                            
                            if let index = myFriendsWagers.firstIndex(of: wagerToDelete.wagerID) {
                                myFriendsWagers.remove(at: index)
                            }
                            
                            let userData = self.db.collection("users").document(friend)
                            userData.setData(["myFriendsWagers": myFriendsWagers], merge: true)
                        }
                    }
                }
        }
    }
    
    //Delete wager from friend's wagerRequests array in Users collection
    func deleteWagerFromFriendsRequests(wagerToDelete: Wager) {
        for friend in wagerToDelete.invitedFriends {
            self.db.collection("users").document(friend)
                .getDocument { (snapshot, error) in
                    if let error = error {
                        print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    } else {
                        if let data = snapshot?.data() {
                            var wagerRequests = data["wagerRequests"] as? [String] ?? []
                            
                            if let index = wagerRequests.firstIndex(of: wagerToDelete.wagerID) {
                                wagerRequests.remove(at: index)
                            }
                            
                            let userData = self.db.collection("users").document(friend)
                            userData.setData(["wagerRequests": wagerRequests], merge: true)
                        }
                    }
                }
        }
    }
    
    ///LEAVE FRIEND'S WAGER
    //Remove Wager from current user's myFriendsWagers array
    func leaveFriendsWager(wagerToLeave: Wager) {
        guard let currentUser = UserController.sharedInstance.currentUser else { return }

        self.db.collection("users").document(currentUser.uid)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let data = snapshot?.data() {
                        var myFriendsWagers = data["myFriendsWagers"] as? [String] ?? []
                        
                        if let index = myFriendsWagers.firstIndex(of: wagerToLeave.wagerID) {
                            myFriendsWagers.remove(at: index)
                        }
                        
                        let currentUserData = self.db.collection("users").document(currentUser.uid)
                        currentUserData.setData(["myFriendsWagers": myFriendsWagers], merge: true)
                    }
                }
            }
    }
    
    //Remove current user from Wager object's acceptedFriends array
    func removeUserFromWager(wagerID: String) {
        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        
        db.collection(wagersCollection).document(wagerID)
            .getDocument { (snapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let data = snapshot?.data() {
                        var invitedFriends = data["invitedFriends"] as? [String] ?? []
                        
                        if let index = invitedFriends.firstIndex(of: currentUser.uid) {
                            invitedFriends.remove(at: index)
                        }
                        
                        let currentUserData = self.db.collection(self.wagersCollection).document(wagerID)
                        currentUserData.setData(["invitedFriends": invitedFriends], merge: true)
                        
                    }
                }
            }
    }
    
    ///DELETE WAGER ASSOCIATED WITH UNFRIENDED USER
    func deleteWagersAssociatedWithUnfriendedUser(_ uid: String) {
        //remove blocked user from current user's invitedFriends in wager object
        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        createWagerArray(wagerStrings: currentUser.myWagers) { (result) in
            switch result {
            case .success(let wagers):
                self.checkIfUserExistsInWagers(uid: uid, wagers: wagers)
            case .failure(let error):
                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        //remove current user from blocked user's invitedFriends in wager object
        db.collection("users").document("uid")
            .getDocument { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let userData = querySnapshot!.data() {
                        let myWagers = userData["myWagers"] as? [String] ?? []
                        
                        self.createWagerArray(wagerStrings: myWagers) { (result) in
                            switch result {
                            case .success(let wagers):
                                self.checkIfUserExistsInWagers(uid: currentUser.uid, wagers: wagers)
                            case .failure(let error):
                                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                            }
                        }
                    }
                }
            }
        
        //remove blocked user's wager from currentUser's myFriendsWagers
        createWagerArray(wagerStrings: currentUser.myFriendsWagers) { (result) in
            switch result {
            case .success(let wagers):
                self.filterCurrentUsersFriendsWagers(uid: uid, wagers: wagers)
            case .failure(let error):
                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        //remove current user's wager from blocked user's myFriendsWagers
        db.collection("users").document("uid")
            .getDocument { (querySnapshot, error) in
                if let error = error {
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let userData = querySnapshot!.data() {
                        let myFriendsWagers = userData["myFriendsWagers"] as? [String] ?? []
                        
                        self.createWagerArray(wagerStrings: myFriendsWagers) { (result) in
                            switch result {
                            case .success(let wagers):
                                self.filterUsersFriendsWagers(uid: uid, wagers: wagers)
                            case .failure(let error):
                                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                            }
                        }
                    }
                }
            }
    }
    
    //remove from wager requests
    
    //utility functions
    func checkIfUserExistsInWagers(uid: String, wagers: [Wager]) {
        for wager in wagers {
            if let index = wager.invitedFriends.firstIndex(of: uid) {
                wager.invitedFriends.remove(at: index)
                
                let wagerData = self.db.collection(self.wagersCollection).document(wager.wagerID)
                wagerData.setData(["invitedFriends": wager.invitedFriends], merge: true)
            }
        }
    }
    
    func filterCurrentUsersFriendsWagers(uid: String, wagers: [Wager]) {
        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        var updatedWagers = [String]()
        
        for index in 0..<wagers.count {
            if wagers[index].owner != uid {
                updatedWagers.append(wagers[index].wagerID)
            }
        }
        
        let userData = self.db.collection("users").document(currentUser.uid)
        userData.setData(["myFriendsWagers": updatedWagers])
    }
    
    func filterUsersFriendsWagers(uid: String, wagers: [Wager]) {
        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        var updatedWagers = [String]()
        
        for index in 0..<wagers.count {
            if wagers[index].owner != currentUser.uid {
                updatedWagers.append(wagers[index].wagerID)
            }
        }
        
        let userData = self.db.collection("users").document(uid)
        userData.setData(["myFriendsWagers": updatedWagers])
    }
    
}//End of class

