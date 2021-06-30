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
    
    func createAndSaveDummyWagers() {
        //3GU1xW4m3Mhgzk7l5bFSCoTk9Az1 - Sally
        //PPR1hHW8x0a7ugkG7FQiYHh8Lnt1 - test
        //TXoF08aoFxU2F3fgwJ1H8HbWsGh2 - Test
        //huN052Z3kJXcApf234j0Y7ds78g2 - Bob
        //rBmkx4W5s0VtdLq6PULrhToCau32 - Jane
        createAndSaveWager(owner: "PPR1hHW8x0a7ugkG7FQiYHh8Lnt1", invitedFriends: ["huN052Z3kJXcApf234j0Y7ds78g2", "rBmkx4W5s0VtdLq6PULrhToCau32"], acceptedFriends: ["3GU1xW4m3Mhgzk7l5bFSCoTk9Az1"], wagerPhoto: UIImage(named: "soccer"), goalDescription: "soccer", wager: "Test Wager", deadline: "Test date", progress: 0.3, completion: { result in
            switch result {
            case .success(let wager):
                self.wagers.append(wager)
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        })
        
        createAndSaveWager(owner: "PPR1hHW8x0a7ugkG7FQiYHh8Lnt1", invitedFriends: ["huN052Z3kJXcApf234j0Y7ds78g2", "rBmkx4W5s0VtdLq6PULrhToCau32"], acceptedFriends: ["3GU1xW4m3Mhgzk7l5bFSCoTk9Az1"], wagerPhoto: UIImage(named: "football"), goalDescription: "football", wager: "Test Wager", deadline: "Test date", progress: 0.5,completion: { result in
            switch result {
            case .success(let wager):
                self.wagers.append(wager)
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        })
        
        createAndSaveWager(owner: "PPR1hHW8x0a7ugkG7FQiYHh8Lnt1", invitedFriends: ["3GU1xW4m3Mhgzk7l5bFSCoTk9Az1", "huN052Z3kJXcApf234j0Y7ds78g2"], acceptedFriends: ["rishi"], wagerPhoto: UIImage(named: "basketball"), goalDescription: "basketball", wager: "Test Wager", deadline: "Test date", progress: 0.7, completion: { result in
            switch result {
            case .success(let wager):
                self.wagers.append(wager)
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        })
        
        createAndSaveWager(owner: "PPR1hHW8x0a7ugkG7FQiYHh8Lnt1", invitedFriends: ["test@test.org", "test@test.com"], acceptedFriends: ["rBmkx4W5s0VtdLq6PULrhToCau32"], wagerPhoto: UIImage(named: "tennis"), goalDescription: "tennis", wager: "Test Wager", deadline: "Test date", progress: 0.4,completion: { result in
            switch result {
            case .success(let wager):
                self.wagers.append(wager)
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        })
        
        createAndSaveWager(owner: "PPR1hHW8x0a7ugkG7FQiYHh8Lnt1", invitedFriends: ["rBmkx4W5s0VtdLq6PULrhToCau32", "TXoF08aoFxU2F3fgwJ1H8HbWsGh2"], acceptedFriends: ["3GU1xW4m3Mhgzk7l5bFSCoTk9Az1"], wagerPhoto: UIImage(named: "gym"), goalDescription: "gym", wager: "Test Wager", deadline: "Test date", progress: 0.2,completion: { result in
            switch result {
            case .success(let wager):
                self.wagers.append(wager)
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        })
    }
    
    func createAndSaveWager(owner: String, invitedFriends: [String], acceptedFriends: [String], wagerPhoto: UIImage?, goalDescription: String, wager: String, deadline: String, progress: Float, completion: @escaping (Result<Wager, DatabaseError>) -> Void) {
        
        let newWager = Wager(owner: owner, invitedFriends: invitedFriends, acceptedFriends: acceptedFriends, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress, wagerPhoto: wagerPhoto)
        
        let wagersRef = db.collection(wagersCollection)
        wagersRef.document("\(newWager.wagerID)").setData([
            "owner": "\(newWager.owner)",
            "wagerPhoto": newWager.wagerPhoto?.jpegData(compressionQuality: 1),
            "goalDescription": "\(newWager.goalDescription)",
            "wager": "\(newWager.wager)",
            "deadline": "\(newWager.deadline)",
            "progress": "\(newWager.progress)"
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
    
    func fetchWager(uuid: String, completion: @escaping (Result<Wager, DatabaseError>) -> Void) {
        let wagersRef = db.collection(wagersCollection)
        
        wagersRef.whereField("uuid", isEqualTo: uuid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error getting wagers with a uuid: \(uuid). - \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                guard let doc = querySnapshot!.documents.first,
                      let fetchedWager = Wager(document: doc) else {
                    return completion(.failure(.couldNotUnwrap))
                }
                return completion(.success(fetchedWager))
            }
        }
    }
}
