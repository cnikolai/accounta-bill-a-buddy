//
//  ForgotPasswordViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Tiffany Sakaguchi on 7/1/21.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        emailTextField.delegate = self
        setupViews()
    }
    
    func setupViews() {
        Utilities.styleFilledButton(resetPasswordButton)
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        
        guard let emailText = emailTextField.text, !emailText.isEmpty else { return }
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailText) { error in
            if error != nil {
                self.showError(error!.localizedDescription)
                return
            }
            self.showSuccess("A password reset email has been sent.")
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func showSuccess (_ message: String) {
        errorLabel.textColor = .systemGreen
        errorLabel.text = message
        errorLabel.alpha = 1
    }

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        resetPasswordButtonTapped(UIButton())
        return true
    }
}

