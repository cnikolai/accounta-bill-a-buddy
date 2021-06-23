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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    //MARK: - Properties
    private enum Screen {
        case login
        case signUp
    }
    private var currentScreen: Screen = .login {
        didSet {
            setupViewFor(screen: currentScreen)
            clearTextFieldsFor(screen: currentScreen)
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
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showError("The password or email is invalid.")
                } else {
                    self.transitionToHome()
                }
            }
        }
        
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
                    self.showError("Error creating user. \(error.localizedDescription)")
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["username": username, "uid": result!.user.uid]) { (error) in
                        if let error = error {
                            self.showError("Error saving user data.")
                            print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                    //transition to home screen
                    self.transitionToHome()
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
    
    private func clearTextFieldsFor(screen: Screen) {
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    func validateFields() -> String? {
        if currentScreen == .signUp {
            if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill in all fields."
            }
            
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedUsername = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Utilities.isPasswordValid(cleanedPassword) == false {
                return "Please make sure your password is at least 6 characters, contains a special character and a number."
            }
            if Utilities.isUsernameValid(cleanedUsername) == false {
                return "Please make sure your username is 2-12 characters long and does not contain special characters."
            }
        }
        if currentScreen == .login {
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill in all fields."
            }
            
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Utilities.isPasswordValid(cleanedPassword) == false {
                return "The password or email is invalid."
            }
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UITabBarController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}//End of class