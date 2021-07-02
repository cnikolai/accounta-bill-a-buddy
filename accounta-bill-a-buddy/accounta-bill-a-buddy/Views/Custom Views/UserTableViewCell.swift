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
    weak var delegate: CustomCellUpdater?
    var selectedSegmentIndex: Int?
    var user: User? {
        didSet {
            updateFindFriendsView()
        }
    }
    var friendsData: [String]? {
        didSet {
            updateFriendsView()
        }
    }
    var friendRequestData: [String]? {
        didSet {
            updateFriendRequestsView()
        }
    }
    
    //MARK: - Actions
    @IBAction func reusableButtonTapped(_ sender: UIButton) {
        if selectedSegmentIndex == 0 {
            addFriend()
        } else if selectedSegmentIndex == 1 {
            showFriendAlert()
        } else {
            showRequestAlert()
        }
    }
    
    //MARK: - Functions
    ///Find and Add Friend
    func updateFindFriendsView() {
        guard let user = user else { return }
        
        usernameLabel.text = user.username
        
        let friendAlreadyAdded = UserController.sharedInstance.friendRequestSent(to: user.uid, username: user.username)
        let friendRequestAlreadyReceived = UserController.sharedInstance.receivedFriendRequest(from: user.uid, username: user.username)
        let friendsAlready = UserController.sharedInstance.friendsAlready(with: user.uid, username: user.username)
        
        if friendAlreadyAdded || friendRequestAlreadyReceived {
            reusableButton.isEnabled = false
            reusableButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            reusableButton.tintColor = .darkGray
        } else if friendsAlready {
            reusableButton.isEnabled = false
            reusableButton.setImage(UIImage(systemName: "person.fill.checkmark"), for: .normal)
            reusableButton.tintColor = .gray
        } else {
            reusableButton.isEnabled = true
            reusableButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            reusableButton.tintColor = .systemBlue
        }
        
    }
    func addFriend() {
        guard let user = user,
              let currentUser = UserController.sharedInstance.currentUser else { return }
        
        let friendAlreadyAdded = UserController.sharedInstance.friendRequestSent(to: user.uid, username: user.username)
        let friendRequestAlreadyReceived = UserController.sharedInstance.receivedFriendRequest(from: user.uid, username: user.username)
        let friendsAlready = UserController.sharedInstance.friendsAlready(with: user.uid, username: user.username)
        
        if !friendAlreadyAdded || !friendRequestAlreadyReceived || !friendsAlready {
            currentUser.sentFriendRequests.append([user.uid : user.username])
            user.receivedFriendRequests.append([currentUser.uid : currentUser.username])
            delegate?.updateTableView()
        } else {
            reusableButton.isEnabled = false
            reusableButton.tintColor = .systemGray
        }
        
        UserController.sharedInstance.pendingFriendRequestBetween(currentUser: currentUser, user: user)
    }
    
    ///Friends List
    func updateFriendsView() {
        guard let friendsData = friendsData else { return }
        usernameLabel.text = friendsData[1]
        reusableButton.isEnabled = true
        reusableButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        reusableButton.tintColor = .systemBlue
    }
    func showFriendAlert() {
        guard let friendsData = friendsData else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Friend", style: .default) { (_) in
            DispatchQueue.main.async {
                UserController.sharedInstance.deleteFriend(uid: friendsData[0], username: friendsData[1])
                self.delegate?.updateTableView()
            }
        }
        let blockAction = UIAlertAction(title: "Block Friend", style: .default) { (_) in
            DispatchQueue.main.async {
                UserController.sharedInstance.blockFriend(uid: friendsData[0], username: friendsData[1])
                self.delegate?.updateTableView()
            }
        }
        let reportAction = UIAlertAction(title: "Report Friend", style: .default) { (_) in
            DispatchQueue.main.async {
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(blockAction)
        alertController.addAction(reportAction)
        alertController.addAction(cancelAction)
        
        parentVC?.present(alertController, animated: true, completion: nil)
    }


    ///Pending Friend Requests
    func updateFriendRequestsView() {
        guard let friendRequestData = friendRequestData else { return }
        usernameLabel.text = friendRequestData[1]
        reusableButton.isEnabled = true
        reusableButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        reusableButton.tintColor = .systemBlue
    }
    func showRequestAlert() {
        guard let friendRequestData = friendRequestData else { return }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let approveAction = UIAlertAction(title: "Approve", style: .default) { (_) in
            DispatchQueue.main.async {
                UserController.sharedInstance.approveOrDenyFriendRequest(uid: friendRequestData[0], username: friendRequestData[1], action: "approve")
                self.delegate?.updateTableView()
            }
        }
        let denyAction = UIAlertAction(title: "Deny", style: .default) { (_) in
            DispatchQueue.main.async {
                UserController.sharedInstance.approveOrDenyFriendRequest(uid: friendRequestData[0], username: friendRequestData[1], action: "deny")
                self.delegate?.updateTableView()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(approveAction)
        alertController.addAction(denyAction)
        alertController.addAction(cancelAction)
        
        parentVC?.present(alertController, animated: true, completion: nil)
    }

}//End of class
