//
//  Utilities.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/17/21.
//

import Foundation

class Utilities {
    
    static func isPasswordValid(_ password: String) -> Bool  {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
}//End of class
