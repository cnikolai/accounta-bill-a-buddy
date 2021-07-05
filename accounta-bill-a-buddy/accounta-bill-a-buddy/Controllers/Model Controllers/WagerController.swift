//
//  WagerController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/24/21.
//

import Foundation
import Firebase

class WagerController {
    
    static let sharedInstance = WagerController()
    let db = Firestore.firestore()
    let wagersCollection = "wagers"
    var wagers: [Wager] = []
    
    func createAndSaveWager(wagerID: String, owner: String, invitedFriends: [String], acceptedFriends: [String], wagerPhoto: UIImage?, goalDescription: String, wager: String, deadline: String, progress: Float, completion: @escaping (Result<Wager, DatabaseError>) -> Void) {
        
        let newWager = Wager(wagerID: wagerID, owner: owner, invitedFriends: invitedFriends, acceptedFriends: acceptedFriends, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress, wagerPhoto: wagerPhoto)
        
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
                        let invitedFriends = wagerData["invitedFriends"] as? [String] ?? []
                        let acceptedFriends = wagerData["acceptedFriends"] as? [String] ?? []
                        let deadline = wagerData["deadline"] as? String ?? ""
                        let progress = wagerData["progress"] as? Float ?? 0.0
                        
                        let newWager = Wager(wagerID: wagerID, owner: owner, invitedFriends: invitedFriends, acceptedFriends: acceptedFriends, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress, wagerPhoto: UIImage(named: "wagerDefaultPhoto"))
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
        guard let indexofWagerToBeRemvoed = UserController.sharedInstance.currentUser?.myWagers.firstIndex(of: wagerId) else { return }
        UserController.sharedInstance.currentUser?.myWagers.remove(at: indexofWagerToBeRemvoed)
        //save currentuser mywagers to database
        UserController.sharedInstance.updateMyWagersList()
        
    }
    
    func addWagerToMyFriendsWagers(wager: Wager) {
        UserController.sharedInstance.currentUser?.myFriendsWagers.append(wager.wagerID)
        guard let indexofWagerToBeChanged = WagerController.sharedInstance.wagers.firstIndex(of: wager) else { return }
        WagerController.sharedInstance.wagers[indexofWagerToBeChanged].acceptedFriends.append(UserController.sharedInstance.currentUser!._uid)
        //save currentuser myfriendswagers and current wager acceptedFriends to database
        UserController.sharedInstance.updateMyFriendsWagersList()
        updateWagerAcceptedFriends(wagerId: wager.wagerID, acceptedFriends: WagerController.sharedInstance.wagers[indexofWagerToBeChanged].acceptedFriends)
    }
    
    func removeCurrentUserFromWagersFriendsList(wager: Wager) {
        guard let indexofWagerToBeChanged = WagerController.sharedInstance.wagers.firstIndex(of: wager) else { return }
        guard let indexofCurrentUserasInvitedFriendofWager = WagerController.sharedInstance.wagers[indexofWagerToBeChanged].invitedFriends.firstIndex(of: UserController.sharedInstance.currentUser!._uid) else { return }
        WagerController.sharedInstance.wagers[indexofWagerToBeChanged].invitedFriends.remove(at: indexofCurrentUserasInvitedFriendofWager)
        //save current wager invitedfriends to database
        updateWagerInvitedFriends(wagerId: wager.wagerID, invitedFriends: WagerController.sharedInstance.wagers[indexofWagerToBeChanged].invitedFriends)
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
    //Delete Wager from Wagers collection
    func deleteWager(wagerID: String) {
        
        fetchWager(wagerID: wagerID) { result in
            switch result {
            case .success(let wager):
                self.deleteWagerFromMyFriendsWagers(wagerToDelete: wager)
                self.deleteWagerFromFriendsRequests(wagerToDelete: wager)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        let wagersRef = db.collection(wagersCollection).document(wagerID)
        wagersRef.delete() { error in
            if let error = error {
                print("Error removing wager document: \(error)")
            } else {
                print("Successfully deleted wager with id: \(wagerID)")
            }
        }
    }
    
    //Delete wager from myWagers array in Users collection
    func deleteWagerFromMyWagers(wagerToDelete: Wager) {
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
    
}//End of class

