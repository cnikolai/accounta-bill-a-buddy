//
//  InviteFriendsTableViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit

protocol InviteFriendsTableViewCellDelegate: AnyObject {
    func saveFriends(_ sender: InviteFriendsTableViewCell)
}

class InviteFriendsTableViewCell: UITableViewCell {

   
    // MARK:-Properties
    var friend: [String:String]? {
        didSet {
            updateViews()
        }
    }
    var inviteWagerFriend = false
    weak var delegate: InviteFriendsTableViewCellDelegate?
    
    // MARK:-Outlets
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var selectFriendButton: UIButton!
    
    @IBAction func didTapFriendButton(_ sender: Any) {
        delegate?.saveFriends(self)
    }
    
    // MARK:-Functions
    func updateViews() {
        guard let friend = friend else { return }
        friendNameLabel.text = friend.values.first
    }
    
    func toggleButton() {
        inviteWagerFriend.toggle()
        
        if inviteWagerFriend {
            selectFriendButton.setImage(UIImage(systemName: "person.crop.circle.badge.checkmark"), for: .normal)
        } else {
            selectFriendButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }

}


