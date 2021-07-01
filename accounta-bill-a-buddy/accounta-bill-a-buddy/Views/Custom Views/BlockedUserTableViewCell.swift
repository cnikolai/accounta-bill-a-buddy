//
//  BlockedUserTableViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/30/21.
//

import UIKit

protocol UnblockUserCellDelegate: AnyObject {
    func unblockUser()
}

class BlockedUserTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: UnblockUserCellDelegate?
    var blockedUser: String? {
        didSet {
            updateView()
        }
    }
    
    //MARK: - Actions
    @IBAction func unblockButtonTapped(_ sender: UIButton) {
        unblockButton.tintColor = .gray
    }
    
    //MARK: - Functions
    func updateView() {
        guard let blockedUser = blockedUser else { return }
        usernameLabel.text = blockedUser
    }

}//End of class
