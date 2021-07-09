//
//  AcceptDenyFriendsViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit
import Firebase

class AcceptDenyFriendsViewController: UIViewController {

    // MARK:-Properties
    var wager: Wager?
    
    // MARK:-Outlets
    @IBOutlet weak var wagerImageView: UIImageView!
    @IBOutlet weak var invitingYouLabel: UILabel!
    @IBOutlet weak var wagerTextView: UITextView!
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var deadlineTextView: UITextView!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWagersOwner()
        setupViews()
    }
    
    // MARK:-Actions
      
    @IBAction func declineButtonTapped(_ sender: Any) {
        guard let wager = wager else { return }
        
        WagerController.sharedInstance.removeCurrentUserFromWagersInvitedFriendsList(wager: wager)
        WagerController.sharedInstance.removeWagerFromMyPendingWagers(wagerId: wager.wagerID)
        
        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        UserController.sharedInstance.getCurrentUser(uid: currentUser.uid) {_ in
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "approveDeclineTapped"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func approveButtonTapped(_ sender: Any) {
        guard let wager = wager else { return }
        WagerController.sharedInstance.addWagerToMyFriendsWagers(wager: wager)
        WagerController.sharedInstance.removeWagerFromMyPendingWagers(wagerId: wager.wagerID)

        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        UserController.sharedInstance.getCurrentUser(uid: currentUser.uid) {_ in
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "approveDeclineTapped"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    

    func dismissView() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCurrentWagersOwner() {
        guard let wager = wager else { return }
        return UserController.sharedInstance.fetchWagerOwnerName(with: wager.owner) { result in
            switch (result) {
            case (let ownerName):
                self.invitingYouLabel.text = ownerName + " is inviting you to a wager!"
            case (let error):
                print("Error in \(#function): \n---\n \(error)")
            }
        }
    }
    
    func setupViews() {
        guard let wager = wager else { return }
        self.wagerImageView.layer.cornerRadius = self.wagerImageView.frame.height / 2

        wagerImageView.image = wager.wagerPhoto
        goalTextView.text = wager.goalDescription
        wagerTextView.text = wager.wager
        deadlineTextView.text = wager.deadline
        Utilities.styleTextView(wagerTextView)
        Utilities.styleTextView(goalTextView)
        Utilities.styleTextView(deadlineTextView)
        Utilities.styleFillButtonRoundedCornersOnly(acceptButton)
        Utilities.styleFillButtonRoundedCornersOnly(declineButton)
        wagerTextView.isUserInteractionEnabled = false
        goalTextView.isUserInteractionEnabled = false
        deadlineTextView.isUserInteractionEnabled = false
    }
}
