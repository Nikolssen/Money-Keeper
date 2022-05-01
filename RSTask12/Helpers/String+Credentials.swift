//
//  String+Credentials.swift
//  RSTask12
//
//  Created by Ivan Budovich on 5/1/22.
//

import Foundation

extension String{
    enum PasswordValidation {
        case empty
        case short
        case invalid
        case valid
    }
    
    enum EmailValidation {
        case empty
        case invalid
        case valid
    }
    
    var isValidEmail: EmailValidation {
        if self.isEmpty {
            return .empty
        }
        
        let regexp = try! NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$")
        let result = regexp.numberOfMatches(in: self, options: [], range: _NSRange(location: 0, length: self.utf16.count)) == 1
        return result ? .valid : .invalid
    }
    
    var isValidPassword: PasswordValidation{
        if self.isEmpty {
            return .empty
        }
        if self.count < 6{
            return .short
        }
        
        let regexp = try! NSRegularExpression(pattern: "^(?=.*[0-9a-zA-Z]).{6,}$")
        let result = regexp.numberOfMatches(in: self, options: [], range: _NSRange(location: 0, length: self.utf16.count)) == 1
        
        return result ? .valid : .invalid
    }
    
    func arePasswordsEqual(password: String)-> PasswordValidation{
        if self.isEmpty {
            return .empty
        }
        if self == password {
            return .valid
        }
        return .invalid
    }
}
