//
//  ConversationsViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/18/21.
//

import Foundation
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseManager.sharedInstance.test()
    }
    
    private func validateAuth() {
        FirebaseAuth.Auth.auth().createUser(with email: "testing@gmail.com", password: "12345", completion {authResult, error in
            guard let result = authResult, error == nil, else {
                print("Error creating user")
                return }
        })
        
        let user = result.user
        print("Created user: \(user)")
    }
}
