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
    
    
    func createDummyWagers() {
        
        let newWager = Wager(owner: "rishikolappa@gmail.com", wagerBuddies: ["test@test.org", "test@test.com"], wagerPhoto: UIImage(named: "soccer"), goalDescription: "soccer", wager: "Test Wager", deadline: "Test date", progress: 0.3, uuid: "001")
        wagers.append(newWager)
        
        let newWager2 = Wager(owner: "rishikolappa@gmail.com", wagerBuddies: ["test@test.org", "test@test.com"], goalDescription: "football", wager: "Test Wager", deadline: "Test date", progress: 0.5, uuid: "002")
        wagers.append(newWager2)
        
        let newWager3 = Wager(owner: "rishikolappa@gmail.com", wagerBuddies: ["test@test.org", "test@test.com"], wagerPhoto: UIImage(named: "basketball"), goalDescription: "basketball", wager: "Test Wager", deadline: "Test date", progress: 0.7, uuid: "003")
        wagers.append(newWager3)
        
        let newWager4 = Wager(owner: "rishikolappa@gmail.com", wagerBuddies: ["test@test.org", "test@test.com"], wagerPhoto: UIImage(named: "tennis"), goalDescription: "tennis", wager: "Test Wager", deadline: "Test date", progress: 0.4, uuid: "004")
        wagers.append(newWager4)
        
        let newWager5 = Wager(owner: "rishikolappa@gmail.com", wagerBuddies: ["test@test.org", "test@test.com"], wagerPhoto: UIImage(named: "gym"), goalDescription: "gym", wager: "Test Wager", deadline: "Test date", progress: 0.2, uuid: "005")
        wagers.append(newWager5)
    }
    
    func createAndSaveWager(owner: String, wagerBuddies: [String], wagerPhoto: UIImage?, goalDescription: String, wager: String, deadline: String, progress: Float, completion: @escaping (Result<Wager, DatabaseError>) -> Void) {
        let newWager = Wager(owner: owner, wagerBuddies: wagerBuddies, wagerPhoto: wagerPhoto, goalDescription: goalDescription, wager: wager, deadline: deadline, progress: progress)
        
        let wagersRef = db.collection(wagersCollection)
        wagersRef.document("\(newWager.uuid)").setData([
            "owner": "\(newWager.owner)",
            "wagerBuddies": "\(newWager.wagerBuddies)",
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
                print("Wager Document added with ID: \(newWager.uuid)")
                return completion(.success(newWager))
            }
        }
    }
    
    
    func fetchAllWagersWithOwner(completion: @escaping (Result<[Wager], DatabaseError>) -> Void) {
                return completion(.success(ownedWagers))
    }
    
    func fetchWagersWithFriends(completion: @escaping (Result<[Wager], DatabaseError>) -> Void) {
         
        return completion(.success(acceptedWagers))
    }
    
    func fetchPendingWagers(completion: @escaping (Result<[Wager], DatabaseError>) -> Void) {
         
        return completion(.success(pendingWagers))
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
