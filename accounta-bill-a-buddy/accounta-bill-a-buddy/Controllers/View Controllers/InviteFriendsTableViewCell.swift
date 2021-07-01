//
//  InviteFriendsTableViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit

protocol InviteFriendsDelegate: AnyObject {
    func addInviteFriendsToCurrentUserFriendsArray(friends: [String])
}

class InviteFriendsTableViewCell: UITableViewCell {

   
    // MARK:-Properties
    var friend: [String:String]? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: InviteFriendsDelegate?
    
    // MARK:-Outlets
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var selectFriendButton: UIButton!
    
    @IBAction func didTapFriendButton(_ sender: Any) {
        if selectFriendButton.currentImage == UIImage(systemName: "circle") {
        selectFriendButton.setImage(UIImage(systemName: "person.crop.circle.badge.checkmark"), for: .normal)
        }
        else {
            selectFriendButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    // MARK:-Functions
    func updateViews() {
        guard let friend = friend else { return }
        friendNameLabel.text = friend.values.first
    }

}
