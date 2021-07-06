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
            selectFriendButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            //selectFriendButton.tintColor = .black
            selectFriendButton.tintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        } else {
            selectFriendButton.setImage(UIImage(systemName: "circle"), for: .normal)
            selectFriendButton.tintColor = .darkGray
        }
    }

}


