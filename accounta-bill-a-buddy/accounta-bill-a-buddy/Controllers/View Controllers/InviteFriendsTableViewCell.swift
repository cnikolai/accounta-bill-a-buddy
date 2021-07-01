//
//  InviteFriendsTableViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit

class InviteFriendsTableViewCell: UITableViewCell {

   
    // MARK:-Properties
    var friend: [String:String]? {
        didSet {
            updateViews()
        }
    }
    
    // MARK:-Outlets
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var selectFriendButton: UIButton!
    
    @IBAction func didTapFriendButton(_ sender: Any) {
        if selectFriendButton.currentImage == UIImage(systemName: "person.fill") {
        selectFriendButton.setImage(UIImage(systemName: "person.fill.checkmark"), for: .normal)
        }
        else {
            selectFriendButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        }
    }
    
    
    // MARK:-Functions
    func updateViews() {
        guard let friend = friend else { return }
        friendNameLabel.text = friend.values.first
    }

}
