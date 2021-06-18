//
//  LoginViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/17/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Properties
    private enum Screen {
        case login
        case signUp
    }
    private var currentScreen: Screen = .login {
        didSet {
            setupViewFor(screen: currentScreen)
        }
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewFor(screen: .login)
    }
    
    //MARK: - Actions
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        currentScreen = (sender.selectedSegmentIndex == 0 ? .login : .signUp)
    }
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.showError("Error creating user")
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    let db = Firestore.firestore()
                }
            }
        }
    }
    
    //MARK: - Functions
    private func setupViewFor(screen: Screen) {
        signUpButton.isHidden = (currentScreen == .login)
        usernameTextField.isHidden = (currentScreen == .login)
        loginButton.isHidden = (currentScreen == .signUp)
        forgotPasswordButton.isHidden = (currentScreen == .signUp)
        errorLabel.alpha = 0
    }

    func validateFields() -> String? {
        if currentScreen == .signUp {
            if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill in all fields."
            }
            
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Utilities.isPasswordValid(cleanedPassword) == false {
                return "Please make sure your password is at least 6 characters, contains a special character and a number."
            }
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}//End of class
