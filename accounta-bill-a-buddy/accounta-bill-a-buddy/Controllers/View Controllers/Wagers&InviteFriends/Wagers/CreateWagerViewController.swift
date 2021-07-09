//
//  CreateWagerViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit
import Firebase

class CreateWagerViewController: UIViewController, UITextViewDelegate {

    // MARK:-Properties
    var wagerFriends: [[String:String]] = []
    var invitedFriendsUIDs: [String] = []
    var invitedFriendsNames: [String] = []
    var photopickerbuttontapped = false
    var wagerPhoto: UIImage = UIImage(named: "wagerDefaultPhoto")!
    
    // MARK:-Outlets
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var photoPickerButton: UIButton!
    @IBOutlet weak var wagerTextView: UITextView!
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var deadlineTextView: UITextView!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var friendsTextView: UITextView!
    
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        wagerTextView.delegate = self
        goalTextView.delegate = self
        deadlineTextView.delegate = self
        InviteFriendsListTableViewController.delegate = self
        EmojiViewController.delegate = self
        setupElements()
        //self.hideKeyboardWhenTappedAround()
    }
    
    func setupElements() {
        inviteFriendsButton.tintColor = #colorLiteral(red: 0.3725490196, green: 0.6705882353, blue: 0.8588235294, alpha: 1)
        Utilities.styleTextView(wagerTextView)
        Utilities.styleTextView(goalTextView)
        Utilities.styleTextView(deadlineTextView)
        Utilities.styleTextView(friendsTextView)
        wagerTextView.text = "Enter wager..."
        goalTextView.text = "Enter goal..."
        deadlineTextView.text = "Enter deadline..."
        wagerTextView.textColor = UIColor.lightGray
        goalTextView.textColor = UIColor.lightGray
        deadlineTextView.textColor = UIColor.lightGray
        showError("Once you create a wager, you cannot invite more friends to the wager", forWhichTextField: "inviteFriends")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Please enter a wager") || (textView.text == "Please enter a goal") || (textView.text == "Please enter a wager deadline") || (textView.text == "Enter wager...")  || (textView.text == "Enter goal...")  || (textView.text == "Enter deadline..."){
            textView.text = ""
            textView.textColor = UIColor.black
            textView.layer.borderWidth = 0.0
    }
        
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.textColor = UIColor.lightGray
//
//            if textView == wagerTextView {
//                textView.text = "Enter wager..."
//            } else if textView == goalTextView {
//                textView.text = "Enter goal..."
//            } else if textView == deadlineTextView {
//                textView.text = "Enter deadline..."
//            }
//        }
    }
    
    @IBAction func inviteFriendsButtonTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "InviteFriends", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "InviteFriendsVC") as! InviteFriendsListTableViewController
        newViewController.modalPresentationStyle = .fullScreen
        friendsTextView.layer.borderWidth = 0.0
        friendsTextView.textColor = .black
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func photoPickerButtonTapped(_ sender: Any) {
        photopickerbuttontapped = true
        let storyBoard: UIStoryboard = UIStoryboard(name: "EmojiPicker", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "EmojiPickerVC") as! EmojiViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func createWagerButtonTapped(_ sender: Any) {
        guard let wager = wagerTextView.text, !wager.isEmpty,!(wager == "Enter wager..."),
              !(wager == "Please enter a wager") else {
            showError("Please enter a wager", forWhichTextField: "wager")
            return }
        guard let goal = goalTextView.text, !goal.isEmpty,!(goal == "Enter goal..."),!(goal == "Please enter a goal") else {
            showError("Please enter a goal", forWhichTextField: "goal")
            return }
        guard let deadline = deadlineTextView.text, !deadline.isEmpty,
              !(deadline == "Enter deadline..."),!(deadline == "Please enter a wager deadline") else {
            showError("Please enter a wager deadline", forWhichTextField: "deadline")
            return }
        guard let wagerPhoto = imageImageView.image as? UIImage else { return }
        WagerController.sharedInstance.createAndSaveWager(wagerID: UUID().uuidString, owner: (UserController.sharedInstance.currentUser?.uid)!, invitedFriends: invitedFriendsUIDs, acceptedFriends: [], goalDescription: goal, wager: wager, deadline: deadline, progress: 0,wagerPhoto: wagerPhoto) { result in
            switch (result) {
            case .success(let wager):
                //add new wager to owner's wager list
                UserController.sharedInstance.appendWagerToOwnerWagerList(wagerId: wager.wagerID)
                //add new wager to all of friends pendingWagers list
                for userfriend in wager.invitedFriends {
                    UserController.sharedInstance.appendWagerToFriendsWagerList(userfriend: userfriend, wagerId: wager.wagerID)
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "createTapped"), object: nil)
                self.dismissView()
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        }        
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }

    
    // MARK:-Functions
    func setupViews() {
        imageImageView.contentMode = .scaleAspectFill
        imageImageView.clipsToBounds = true
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textColor = .black
        textField.layer.borderWidth = 0.0
    }
    
    func showError(_ message: String, forWhichTextField: String) {
        if forWhichTextField == "wager" {
            wagerTextView.text = message
            wagerTextView.textColor = .red
            wagerTextView.layer.borderColor = UIColor.red.cgColor
            wagerTextView.layer.borderWidth = 1.0
        }
        if forWhichTextField == "goal" {
            goalTextView.text = message
            goalTextView.textColor = .red
            goalTextView.layer.borderColor = UIColor.red.cgColor
            goalTextView.layer.borderWidth = 1.0
        }
        if forWhichTextField == "deadline" {
            deadlineTextView.text = message
            deadlineTextView.textColor = .red
            deadlineTextView.layer.borderColor = UIColor.red.cgColor
            deadlineTextView.layer.borderWidth = 1.0
        }
        if forWhichTextField == "inviteFriends" {
            friendsTextView.text = message
            friendsTextView.textColor = .red
            friendsTextView.layer.borderColor = UIColor.red.cgColor
            friendsTextView.layer.borderWidth = 1.0
        }
    }
}//end of class

extension CreateWagerViewController: InviteFriendsListTableViewControllerDelegate {
    func passFriends(_ sender: InviteFriendsListTableViewController) {
        print("invited friends2: \(sender.wagerFriends)")
        //reset the friends names and uuids of the friends just in case the user has selected the friends button twice
        invitedFriendsNames = []
        invitedFriendsUIDs = []
        wagerFriends = sender.wagerFriends
        for friend in wagerFriends {
            for key in friend.keys {
                invitedFriendsUIDs.append(key)
            }
            for value in friend.values {
                invitedFriendsNames.append(value)
            }
        }
        print(invitedFriendsUIDs)
        print(invitedFriendsNames)
        friendsTextView.text = invitedFriendsNames.joined(separator: ", ")
    }
}

//extension CreateWagerViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateWagerViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

extension CreateWagerViewController: EmojiViewControllerDelegate {
    func saveEmoji(_ emoji: UIImage) {
        imageImageView.image = emoji
        photoPickerButton.setImage(nil, for: .normal)
    }
}
