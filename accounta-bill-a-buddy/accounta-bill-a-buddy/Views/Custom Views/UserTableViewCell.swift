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
    @IBOutlet weak var addFriendButtonTapped: UIButton!
    
    //MARK: - Functions
    func updateView() {
//        usernameLabel.text = user.username
    }

}//End of class
