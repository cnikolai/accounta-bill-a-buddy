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
    
    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        try! Auth.auth().signOut()
        
//        if let storyboard = self.storyboard {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
//            self.present(vc, animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//        }
    }
    
    //MARK: - Functions
    func updateView() {
        profileLabel.text = UserController.sharedInstance.currentUser?.username
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}//End of class
