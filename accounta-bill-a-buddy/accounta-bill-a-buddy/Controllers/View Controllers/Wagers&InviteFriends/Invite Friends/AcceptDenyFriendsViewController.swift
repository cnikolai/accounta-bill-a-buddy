//
//  AcceptDenyFriendsViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit

class AcceptDenyFriendsViewController: UIViewController {

    // MARK:-Properties
    var wager: Wager?
    
    // MARK:-Outlets
    @IBOutlet weak var wagerImageView: UIImageView!
    @IBOutlet weak var invitingYouLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var wagerLabel: UITextField!
    @IBOutlet weak var deadlineLabel: UITextField!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWagersOwner()
        setupViews()
    }
    
    // MARK:-Actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {
        guard let wager = wager else { return }
        
        WagerController.sharedInstance.removeCurrentUserFromWagersInvitedFriendsList(wager: wager)
        WagerController.sharedInstance.removeWagerFromMyPendingWagers(wagerId: wager.wagerID)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func approveButtonTapped(_ sender: Any) {
        guard let wager = wager else { return }
        WagerController.sharedInstance.addWagerToMyFriendsWagers(wager: wager)
        WagerController.sharedInstance.removeWagerFromMyPendingWagers(wagerId: wager.wagerID)

        self.dismiss(animated: true, completion: nil)
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
        wagerImageView.image = wager.wagerPhoto
        goalDescriptionLabel.text = wager.goalDescription
        wagerLabel.text = wager.wager
        deadlineLabel.text = wager.deadline
    }
}