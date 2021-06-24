//
//  CreateWagerDetailViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit

class CreateWagerDetailViewController: UIViewController {
    
    // MARK:-Outlets
    @IBOutlet weak var wagerLabel: UIButton!
    @IBOutlet weak var goalLabel: UIButton!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:-Actions
    @IBAction func photoPickerButtonTapped(_ sender: Any) {
        
    }
    @IBAction func createWagerButtonTapped(_ sender: Any) {
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
}

        let imagePicker = UIImagePickerController()
        
        @IBOutlet weak var selectPhotoButton: UIButton!
        @IBOutlet weak var photoImageView: UIImageView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
        }
        
        @IBAction func selectPhotoButtonTapped(_ sender: Any) {
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
        
        func setupViews() {
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            photoImageView.backgroundColor = .black
            imagePicker.delegate = self
        }
    }

    extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
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
                guard let delegate = delegate
                    else { return }
                delegate.photoPickerSelected(image: pickedImage)
                photoImageView.image = pickedImage
                change title of button.
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }

}
