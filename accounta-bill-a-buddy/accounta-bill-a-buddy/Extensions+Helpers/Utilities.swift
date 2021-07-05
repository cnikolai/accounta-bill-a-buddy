//
//  Utilities.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/17/21.
//

import UIKit

class Utilities {
    
    static func isPasswordValid(_ password: String) -> Bool  {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isUsernameValid(_ username: String) -> Bool {
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", "^[0-9a-z\\_]{2,12}$")
        return usernameTest.evaluate(with: username)
    }
    
    static func styleTextView(_ textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 10
    }
    
//    static func friendsLabel(_ label: UILabel) {
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.systemGray4.cgColor
//        label.layer.cornerRadius = 10
//    }
    
}//End of class
