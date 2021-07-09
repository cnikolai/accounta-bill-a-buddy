//
//  WagerCollectionViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit
import Firebase

protocol DeleteCellDelegate: AnyObject {
    func deleteCellWith(wager: Wager, selectedSegmentIndex: Int)
}

class WagerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var wagerImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: DeleteCellDelegate?
    var selectedSegmentIndex: Int?
    var myWager: Wager? {
        didSet {
            updateMyWagersView()
        }
    }
    var myFriendsWager: Wager? {
        didSet {
            updateMyFriendsWagersView()
        }
    }
    var wagerRequest: Wager? {
        didSet {
            updateRequestedView()
        }
    }
    
    //MARK: - Actions
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if selectedSegmentIndex == 0  {
            guard let myWager = myWager else { return }
            print(myWager.wagerID)
            delegate?.deleteCellWith(wager: myWager, selectedSegmentIndex: 0)
        } else if selectedSegmentIndex == 1 {
            guard let myFriendsWager = myFriendsWager else { return }
            delegate?.deleteCellWith(wager: myFriendsWager, selectedSegmentIndex: 1)
        } else {
            return
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wagerImageView.image = nil
    }
    
    //MARK: - Functions
    func updateMyWagersView() {
        guard let myWager = myWager else {return}
        deleteButton.isEnabled = true
        deleteButton.isHidden = false
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        //let storageRef = storage.reference()
        // Create a reference from a Google Cloud Storage URI
        print("=================================2",myWager.firebasePhotoURL)
        let gsReference = storage.reference(forURL: myWager.firebasePhotoURL)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.wagerImageView?.image = image
            self.wagerImageView?.layer.cornerRadius = self.wagerImageView.frame.height / 2
          }
        }
    }
    
    func updateMyFriendsWagersView() {
        guard let myFriendsWager = myFriendsWager else {return}
        deleteButton.isEnabled = true
        deleteButton.isHidden = false
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        //let storageRef = storage.reference()
        // Create a reference from a Google Cloud Storage URI
        print("========================================3",myFriendsWager.firebasePhotoURL)
        let gsReference = storage.reference(forURL: myFriendsWager.firebasePhotoURL)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
        } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.wagerImageView?.image = image
            self.wagerImageView?.layer.cornerRadius = self.wagerImageView.frame.height / 2
          }
        }
        //wagerImageView?.image = myFriendsWager.wagerPhoto
        //wagerImageView?.layer.cornerRadius = wagerImageView.frame.height / 2
    }
    
    func updateRequestedView() {
        guard let wagerRequest = wagerRequest else {return}
        deleteButton.isEnabled = false
        deleteButton.isHidden = true
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        // Create a reference from a Google Cloud Storage URI
        print("========================================4",wagerRequest.firebasePhotoURL)

        let gsReference = storage.reference(forURL: wagerRequest.firebasePhotoURL)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")

          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.wagerImageView?.image = image
            self.wagerImageView?.layer.cornerRadius = self.wagerImageView.frame.height / 2
          }
        }
        //wagerImageView?.image = wagerRequest.wagerPhoto
        //wagerImageView?.layer.cornerRadius = wagerImageView.frame.height / 2
    }
    
}//End of class
