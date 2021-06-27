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
    @IBOutlet weak var reusableButton: UIButton!
    
    //MARK: - Properties
    var parentVC: UIViewController?
    var selectedSegmentIndex: Int?
    var user: User? {
        didSet {
            updateFindFriendsView()
        }
    }
    var request: String? {
        didSet {
            updateRequestsView()
        }
    }
    
    //MARK: - Actions
    @IBAction func reusableButtonTapped(_ sender: UIButton) {
        if selectedSegmentIndex == 0 {
            addFriend()
        } else if selectedSegmentIndex == 1 {
            
        } else {
            showRequestAlert()
        }
    }
    
    //MARK: - Functions
    func updateFindFriendsView() {
        guard let user = user else { return }
        usernameLabel.text = user.username
        reusableButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
    }
    
    func updateRequestsView() {
        guard let request = request else { return }
        usernameLabel.text = request
        reusableButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    func addFriend() {
        guard let user = user,
              let currentUser = UserController.sharedInstance.currentUser else { return }
        user.receivedFriendRequests.append([currentUser.uid : currentUser.username])
        currentUser.sentFriendRequests.append([user.uid : user.username])
        
        UserController.sharedInstance.pendingFriendRequestBetween(currentUser: currentUser, user: user)
    }
    
    func showRequestAlert() {
        guard let request = request else { return }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let approveAction = UIAlertAction(title: "Approve", style: .default) { (_) in
            DispatchQueue.main.async {
                UserController.sharedInstance.approveOrDenyFriendRequest(from: request)
            }
        }
        let denyAction = UIAlertAction(title: "Deny", style: .default) { (_) in
            DispatchQueue.main.async {
                UserController.sharedInstance.approveOrDenyFriendRequest(from: request)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(approveAction)
        alertController.addAction(denyAction)
        alertController.addAction(cancelAction)
        
        parentVC?.present(alertController, animated: true, completion: nil)
    }

}//End of class
