//
//  BlockedUserTableViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/30/21.
//

import UIKit

class BlockedUserTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    //MARK: - Properties
    var blockedUser: [String]? {
        didSet {
            updateView()
        }
    }
    
    //MARK: - Actions
    @IBAction func unblockButtonTapped(_ sender: UIButton) {
        guard let blockedUser = blockedUser else { return }
        UserController.sharedInstance.unblockUser(uid: blockedUser[0], username: blockedUser[1])
        unblockButton.backgroundColor = .systemGray
        unblockButton.isEnabled = false
    }
    
    //MARK: - Functions
    func updateView() {
        guard let blockedUser = blockedUser else { return }
        unblockButton.isEnabled = true
        unblockButton.backgroundColor = #colorLiteral(red: 0.4386562784, green: 0.7151943089, blue: 0.866738155, alpha: 1)
        usernameLabel.text = blockedUser[1]
    }

}//End of class
