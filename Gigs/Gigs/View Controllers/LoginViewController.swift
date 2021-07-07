//
//  LoginViewController.swift
//  Gigs
//
//  Created by Dahna on 5/5/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    
    // MARK: Outlets
    
    @IBOutlet weak var loginSegmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            loginButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController?.signUp(with: user, completion: { result in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Please Log In", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .logIn
                                    self.loginSegmentedController.selectedSegmentIndex = 1
                                    self.loginButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            } else {
                gigController?.signIn(with: user, completion: { result in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? GigController.NetworkError {
                            switch error{
                            case .failedSignIn:
                                print("Sign in failed")
                            case .noData, .noToken:
                                print("No data received")
                            default:
                                print("Other Error occurred")
                            }
                        }
                    }
                })
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 8.0
    }
    


}
