//
//  AcceptRejectFriendsViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit

class AcceptRejectFriendsViewController: UIViewController {

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
        let owner = fetchCurrentWagersOwner()
        invitingYouLabel.text = owner + " is inviting you to a wager!"
    }
    
    // MARK:-Actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {
        guard let wager = wager else { return }
        WagerController.sharedInstance.removeWagerFromMyPendingWagers(wagerId: wager.wagerID)
        WagerController.sharedInstance.addWagerToMyFriendsWagers(wager: wager)
    }
    
    @IBAction func approveButtonTapped(_ sender: Any) {
        guard let wager = wager else { return }
        WagerController.sharedInstance.removeWagerFromMyPendingWagers(wagerId: wager.wagerID)
        WagerController.sharedInstance.removeCurrentUserFromWagersFriendsList(wager: wager)
    }
    
    func dismissView() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchCurrentWagersOwner() -> String {
        guard let wager = wager else { return "" }
        return wager.owner
    }
}
