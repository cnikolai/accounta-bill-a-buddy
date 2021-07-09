//
//  ProfileViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/30/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var blockedUsersButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateView()
    }
    
    func setupViews() {
        Utilities.styleFilledButton(blockedUsersButton)
        Utilities.styleFilledButton(logOutButton)
    }
    
    //MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            try! Auth.auth().signOut()

            if Auth.auth().currentUser == nil {
                let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC")
                rootController.modalPresentationStyle = .fullScreen
                self.present(rootController, animated: true, completion: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func updateView() {
        profileLabel.text = UserController.sharedInstance.currentUser?.username
    }
}//End of class
