//
//  Validator.swift
//  MyPick
//
//  Created by Holly McBride on 13/03/2023.
//

import Foundation

class Validator {
    
    //VALIDATION for email signin
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //VALIDATION for username
    //Username must be within 4-24 characters long
    static func isValidUsername(for username: String) ->Bool {
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameRegEx = "\\w{4,24}"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@",
        usernameRegEx)
        return usernamePred.evaluate(with: username)
    }
    
    //VALIDATION for password
    //Must include letters from a-z
    //must include speical character (?=.*[$@$#!%*?&])
    //Must be between 6-32 characters long
    static func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@",
        passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
