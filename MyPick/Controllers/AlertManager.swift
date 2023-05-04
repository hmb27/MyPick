//
//  AlertManager.swift
//  MyPick
//
//  Created by Holly McBride on 12/03/2023.
//

import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
    
}

// MARK: Show validation alerts
extension AlertManager {
    
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please enter a valid Password.")
    }
    
    public static func showInvalidUsername(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Username", message: "Please enter a valid Username.")
    }
}


// MARK: Show registration error
extension AlertManager {
    
    
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unkown Registration Error", message: nil)
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Unkown Registration Error", message: "\(error.localizedDescription)")
    }
}


// MARK: Show Log in Error
extension AlertManager {
    
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unkown Error Signing In", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Signing In", message: "\(error.localizedDescription)")
    }
}

// MARK: Show Log Out Error
extension AlertManager {
    
    public static func showLogoutError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Log Out Error", message: "\(error.localizedDescription)")
        
    }
}

// MARK: Forgot Password
extension AlertManager {
    
    
    
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Password Reset Sent", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Sending Password Reset", message: "\(error.localizedDescription)")
        
    }
    
}

// MARK: Fetching User Errors
extension AlertManager {
    
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
        
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Error Fetching User", message: nil)
    }
    
}

extension AlertManager {
    
    public static func showDuplicateAdd(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error: You have already connected", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownDuplicateAddError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Duplicate Error", message: nil)
    }
    
}

extension AlertManager {
    
    public static func searchNotAvail(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Sorry, the movie you searched for is not available on any of your services", message: "\(error.localizedDescription)")
    }
    
    public static func searchNotAvailError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown search error", message: nil)
    }
}


                            

