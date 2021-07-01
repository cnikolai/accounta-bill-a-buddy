//
//  AcceptRejectFriendsViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit

class AcceptRejectFriendsViewController: UIViewController {

    // MARK:-Outlets
    @IBOutlet weak var wagerImageView: UIImageView!
    @IBOutlet weak var invitingYouLabel: UILabel!
   
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var wagerLabel: UITextField!
    @IBOutlet weak var deadlineLabel: UITextField!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:-Actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func rejectButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func approveButtonTapped(_ sender: Any) {
        
    }
    
    func dismissView() {
        
    }
}
