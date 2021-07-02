//
//  CreateWagerViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit

class CreateWagerViewController: UIViewController {

    // MARK:-Properties
    let imagePicker = UIImagePickerController()
    var wagerFriends: [[String:String]] = []
    var invitedFriendsUIDs: [String] = []
    
    // MARK:-Outlets
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var photoPickerButton: UIButton!
    @IBOutlet weak var wagerTextField: UITextView!
    @IBOutlet weak var goalTextField: UITextView!
    @IBOutlet weak var deadlineTextField: UITextView!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        InviteFriendsListTableViewController.delegate = self
    }
    
    @IBAction func inviteFriendsButtonTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "InviteFriends", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "InviteFriendsVC") as! InviteFriendsListTableViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func photoPickerButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func createWagerButtonTapped(_ sender: Any) {
        guard let wager = wagerTextField.text, !wager.isEmpty,
              !(wager == "\nWhat is your Wager?"), !(wager == "\nPlease enter a wager") else {
            showError("\nPlease enter a wager", forWhichTextField: "wager")
            return }
        guard let goal = goalTextField.text, !goal.isEmpty, !(goal == "\n\nWhat is your Goal?"),!(goal == "\n\nPlease enter a goal") else {
            showError("\n\nPlease enter a goal", forWhichTextField: "goal")
            return }
        guard let deadline = deadlineTextField.text, !deadline.isEmpty,
              !(deadline == "What is the Wager Deadline?"), !(deadline == "\nPlease enter a wager deadline") else {
            showError("\nPlease enter a wager deadline", forWhichTextField: "deadline")
            return }
        WagerController.sharedInstance.createAndSaveWager(owner: (UserController.sharedInstance.currentUser?.uid)!, invitedFriends: invitedFriendsUIDs, acceptedFriends: [], wagerPhoto: imageImageView.image, goalDescription: goal, wager: wager, deadline: deadline, progress: 0) { result in
            switch (result) {
            case .success(let wager):
                //add new wager to owner's wager list
                UserController.sharedInstance.appendWagerToOwnerWagerList(wagerId: wager.wagerID)
                //add new wager to all of friends pendingWagers list
                for userfriend in wager.invitedFriends {
                    UserController.sharedInstance.appendWagerToFriendsWagerList(userfriend: userfriend, wagerId: wager.wagerID)
                }
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
        imagePicker.delegate = self
    }
    
    private func dismissView() {
        //DispatchQueue.main.async {
            //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        //}
    }
}

extension CreateWagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "No Camera Access", message: "Please allow access to the camera to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        func openGallery() {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "No Photos Access", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                imageImageView.image = pickedImage
                photoPickerButton.setImage(nil, for: .normal)
            }
            picker.dismiss(animated: true, completion: nil)
        }

    func showError(_ message: String, forWhichTextField: String) {
        if forWhichTextField == "wager" {
            wagerTextField.text = message
            wagerTextField.textColor = .red
            wagerTextField.layer.borderColor = UIColor.red.cgColor
            wagerTextField.layer.borderWidth = 1.0
        }
        if forWhichTextField == "goal" {
            goalTextField.text = message
            goalTextField.textColor = .red
            goalTextField.layer.borderColor = UIColor.red.cgColor
            goalTextField.layer.borderWidth = 1.0
        }
        if forWhichTextField == "deadline" {
            deadlineTextField.text = message
            deadlineTextField.textColor = .red
            deadlineTextField.layer.borderColor = UIColor.red.cgColor
            deadlineTextField.layer.borderWidth = 1.0
        }
        
    }
}//eoc

extension CreateWagerViewController: InviteFriendsListTableViewControllerDelegate {
    func passFriends(_ sender: InviteFriendsListTableViewController) {
        print("invited friends2: \(sender.wagerFriends)")
        wagerFriends = sender.wagerFriends
        for friend in wagerFriends {
            for key in friend.keys {
                invitedFriendsUIDs.append(key)
            }
        }
        print(invitedFriendsUIDs)
        //inviteFriendsButton.setTitle( invitedFriendsUUIs.joined(separator: ", "), for: .normal)
    }
}

