//
//  WagerDetailViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit

class WagerDetailViewController: UIViewController {

    // MARK:-Properties
    var progress: Float?
    
    var wager: Wager? {
        didSet {
            //updateViews()
        }
    }
    var owner: Bool?
    //a variable to keep track of when we are editing a view versus just viewing a view (segment #0 versus segment #1)
    var edit: Bool?
    
    // MARK:-Outlets
    @IBOutlet weak var wagerTextView: UITextView!
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var deadlineTextView: UITextView!
    @IBOutlet weak var invitedFriendsTextView: UITextView!
    @IBOutlet weak var wagerPhotoImageView: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.hidesBackButton = true;
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
    }
    
    // MARK:-Actions
    @IBAction func progressSliderTapped(_ sender: UISlider) {
        print("slider value: ", sender.value)
        progress = sender.value
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let wager = wager,
              let owner = owner else { return }
        guard let goalDescription = goalTextView.text,
              let wagertext = wagerTextView.text,
              let deadline = deadlineTextView.text,
              let progress = progressSlider?.value else { return }
        //update wager in currentview
        wager.goalDescription = goalDescription
        wager.wager = wagertext
        wager.deadline = deadline
        wager.progress = progress
        //update wager in database
        WagerController.sharedInstance.updateWager(wager: wager)
        //update wager in app
        if (owner) {
            UserController.sharedInstance.updateMyWagersList(with: wager)
        }
        else {
            UserController.sharedInstance.updateMyFriendsWagersList(with: wager)

        }
        dismissView()
    }
    
    private func dismissView() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViews() {
        guard let wager = wager else {return}
        guard let edit = edit else { return }
        if !edit {
            //disable text fields from input
            goalDescriptionTextField.isEnabled = false
            goalDescriptionTextField.isUserInteractionEnabled = false
            wagerTextField.isEnabled = false
            wagerTextField.isUserInteractionEnabled = false
            progressSlider.isEnabled = false
            progressSlider.isUserInteractionEnabled = false
            //hide friends
            invitedFriendsLabel.isHidden = true
        }
        wagerPhotoImageView.image = wager.wagerPhoto
        goalTextView.text = wager.goalDescription
        deadlineTextView.text = wager.deadline
        wagerTextView.text = wager.wager
        progressSlider.value = wager.progress
        UserController.sharedInstance.fetchInvitedFriendsNames(for: wager.invitedFriends, completion: { result in
            switch result {
            case .success(let invitedFriendsNames):
                self.invitedFriendsTextView.text = invitedFriendsNames.joined(separator: ", ")
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        })
    }

}
