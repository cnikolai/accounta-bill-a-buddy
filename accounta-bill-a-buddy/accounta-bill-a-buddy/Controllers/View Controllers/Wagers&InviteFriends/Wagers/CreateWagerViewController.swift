//
//  CreateWagerViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit
import Firebase
import FirebaseStorage

class CreateWagerViewController: UIViewController, UITextViewDelegate {

    // MARK:-Properties
    let imagePicker = UIImagePickerController()
    var wagerFriends: [[String:String]] = []
    var invitedFriendsUIDs: [String] = []
    var invitedFriendsNames: [String] = []
    var photopickerbuttontapped = false
    var firebasePhotoURL: String = "https://firebasestorage.googleapis.com:443/v0/b/accounta-bill-a-buddy-43cbd.appspot.com/o/B02A43F1-7243-4190-B052-ABF0061EB8E8.jpg?alt=media&token=9a8df5d4-ec79-409f-9d44-d11ac0a2970c"
    
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
        
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.hidesBackButton = true;
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        InviteFriendsListTableViewController.delegate = self
        setupElements()
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
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            
            if textView == wagerTextView {
                textView.text = "Enter wager..."
            } else if textView == goalTextView {
                textView.text = "Enter goal..."
            } else if textView == deadlineTextView {
                textView.text = "Enter deadline..."
            }
        }
    }
    
    @IBAction func inviteFriendsButtonTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "InviteFriends", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "InviteFriendsVC") as! InviteFriendsListTableViewController
        //newViewController.modalPresentationStyle = .fullScreen
        friendsTextView.layer.borderWidth = 0.0
        friendsTextView.textColor = .black
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func photoPickerButtonTapped(_ sender: Any) {
        photopickerbuttontapped = true
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
//        if !photopickerbuttontapped {
//            //imageImageView.image = UIImage(named: "wagerDefaultPhoto")
//            firebasePhotoURL = "https://firebasestorage.googleapis.com:443/v0/b/accounta-bill-a-buddy-43cbd.appspot.com/o/B02A43F1-7243-4190-B052-ABF0061EB8E8.jpg?alt=media&token=9a8df5d4-ec79-409f-9d44-d11ac0a2970c"
//        }
        WagerController.sharedInstance.createAndSaveWager(wagerID: UUID().uuidString, owner: (UserController.sharedInstance.currentUser?.uid)!, invitedFriends: invitedFriendsUIDs, acceptedFriends: [], goalDescription: goal, wager: wager, deadline: deadline, progress: 0,firebasePhotoURL:firebasePhotoURL) { result in
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
        self.dismiss(animated: true, completion: nil)
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
                //let imgURL = info[UIImagePickerController.InfoKey.imageURL]
                //let mediaURL = info[UIImagePickerController.InfoKey.mediaURL]
                
                //store data in firestore
                guard let im: UIImage = info[.originalImage] as? UIImage else { return }
                guard let d: Data = im.jpegData(compressionQuality: 0.5) else { return }

                let md = StorageMetadata()
                md.contentType = "image/jpg"//png too

                let f = UserController.sharedInstance.currentUser!.uid + "/" + UUID().uuidString + ".jpg"
                //let f = UUID().uuidString + ".jpg"
                let ref = Storage.storage().reference().child(f)
                
                ref.putData(d, metadata: md) { (metadata, error) in
                     if error == nil {
                         ref.downloadURL(completion: { (url, error) in
                             print("Done, url is \(String(describing: url))")
                            guard let unwrappedURL = url?.absoluteString else { return }
                            self.firebasePhotoURL = unwrappedURL
                         })
                     }else{
                         print("error \(String(describing: error))")
                     }
                 }
            }
            picker.dismiss(animated: true, completion: nil)
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

