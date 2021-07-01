//
//  ProfileViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/30/21.
//

import UIKit

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
        
    }
    
    //MARK: - Functions
    func updateView() {
        profileLabel.text = UserController.sharedInstance.currentUser?.username
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}//End of class
