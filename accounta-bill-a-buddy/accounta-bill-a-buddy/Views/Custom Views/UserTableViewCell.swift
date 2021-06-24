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
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    //MARK: - Actions
    @IBAction func addFriendButtonTapped(_ sender: UIButton) {
        guard let user = user,
              let currentUser = UserController.sharedInstance.currentUser else { return }
        user.friendRequestsFrom.append(currentUser.uid)
        currentUser.friendRequestsTo.append(user.uid)
        
        UserController.sharedInstance.pendingFriendRequestBetween(currentUser: currentUser, user: user)
    }
    
    //MARK: - Functions
    func updateView() {
        guard let user = user else { return }
        usernameLabel.text = user.username
    }

}//End of class
