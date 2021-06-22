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
<<<<<<< Updated upstream
//        usernameLabel.text = user.username
=======
        guard let user = user else { return }
        usernameLabel.text = user.username
>>>>>>> Stashed changes
    }

}//End of class
