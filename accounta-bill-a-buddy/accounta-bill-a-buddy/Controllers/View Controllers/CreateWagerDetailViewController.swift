//
//  CreateWagerDetailViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit

class CreateWagerDetailViewController: UIViewController {
    
    // MARK:-Properties
    let imagePicker = UIImagePickerController()
    
    // MARK:-Outlets
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var photoPickerButton: UIButton!
    @IBOutlet weak var wagerTextField: UITextView!
    @IBOutlet weak var goalTextField: UITextView!
    
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK:-Actions
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
              !(wager == "\nWhat is your Wager?") else {
            showError("\nPlease enter a wager", forWhichTextField: "wager")
            return }
        guard let goal = goalTextField.text, !goal.isEmpty, !(goal == "\n\nWhat is your Goal?") else {
            showError("\n\nPlease enter a goal", forWhichTextField: "goal")
            return }
        WagerController.sharedInstance.createAndSaveWager(owner: UserController.sharedInstance.currentUser?.username ?? "Guest User", wagerBuddies: [], wagerPhoto: imageImageView.image, goalDescription: goal, wager: wager, deadline: "", progress: 0) { result in
            switch (result) {
            case .success(let wager):
                self.dismissView()
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
            }
        }
        dismissView()
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
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CreateWagerDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
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
        
    }
}
