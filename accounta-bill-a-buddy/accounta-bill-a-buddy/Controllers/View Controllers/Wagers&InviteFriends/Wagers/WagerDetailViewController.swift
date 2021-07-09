//
//  WagerDetailViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit
import Firebase

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
    @IBOutlet weak var wagerOwnerLabel: UILabel!
    @IBOutlet weak var wagerTextView: UITextView!
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var deadlineTextView: UITextView!
    @IBOutlet weak var invitedFriendsTextView: UITextView!
    @IBOutlet weak var wagerPhotoImageView: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var invitedFriendsLabel: UILabel!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupViews()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupViews() {
        Utilities.styleTextView(wagerTextView)
        Utilities.styleTextView(goalTextView)
        Utilities.styleTextView(deadlineTextView)
        Utilities.styleTextView(invitedFriendsTextView)
        invitedFriendsTextView.backgroundColor = UIColor.lightGray
        invitedFriendsTextView.layer.borderWidth = 0.0
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
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
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
            progressSlider.isEnabled = false
            progressSlider.isUserInteractionEnabled = false
            //hide friends
            invitedFriendsTextView.isHidden = true
            invitedFriendsLabel.isHidden = true
            wagerOwnerLabel.isHidden = false
            let ownername: () = UserController.sharedInstance.fetchWagerOwnerName(with: wager.owner, completion: { ownername in
                    self.wagerOwnerLabel.text = "\(ownername)'s Wager!"
            })
        }
        else {
            wagerOwnerLabel.isHidden = true
        }
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        //let storageRef = storage.reference()
        print("========================================1",wager.firebasePhotoURL)
        let gsReference = storage.reference(forURL: wager.firebasePhotoURL)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.wagerPhotoImageView.image = image
            //self.wagerPhotoImageView.layer.cornerRadius = self.wagerImageView.frame.height / 2
          }
        }
        //wagerPhotoImageView.image = wager.wagerPhoto
        goalTextView.text = wager.goalDescription
        deadlineTextView.text = wager.deadline
        wagerTextView.text = wager.wager
        progressSlider.value = wager.progress
        UserController.sharedInstance.fetchInvitedFriendsNames(for: wager.invitedFriends, completion: { result in
            switch result {
                case .success(let invitedFriendsNames):
                    self.invitedFriendsTextView.text = invitedFriendsNames.joined(separator: ", ")
                    self.invitedFriendsTextView.backgroundColor = .white
                case .failure(let error):
                    print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        })
        
    }

}

extension WagerDetailViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(WagerDetailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
