//
//  FriendTableViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/19/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    //MARK: - Properties
//    var tapped = false
    var user: User? {
        didSet {
//            tapped = false
            updateView()
        }
    }
    var request: String? {
        didSet {
            updateView()
        }
    }
    
    //MARK: - Actions
    @IBAction func addFriendButtonTapped(_ sender: UIButton) {
        guard let user = user,
              let currentUser = UserController.sharedInstance.currentUser else { return }
        user.receivedFriendRequests.append(currentUser.uid)
        currentUser.sentFriendRequests.append(user.uid)
        
        UserController.sharedInstance.pendingFriendRequestBetween(currentUser: currentUser, user: user)
        
//        tapped = true
//
//        if tapped {
//            addFriendButton.setTitleColor(.gray, for: .normal)
//            sender.isEnabled = false
//        } else {
//            addFriendButton.setTitleColor(.blue, for: .normal)
//            sender.isEnabled = true
//        }
    }
    
    //MARK: - Functions
    func updateView() {
        guard let user = user else { return }
        usernameLabel.text = user.username
        
        guard let request = request else { return }
        usernameLabel.text = request
    }

}//End of class
