//
//  LoginViewController.swift
//  Gigs
//
//  Created by Dahna on 4/7/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

enum LoginType: String {
    case signUp = "Sign Up"
    case signIn = "Sign In"
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpLogInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    private lazy var viewModel = LoginViewModel()
    static let identifier: String = String(describing: LoginViewController.self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            loginType = .signIn
            passwordTextField.textContentType = .password
        default:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        }
        
        submitButton.setTitle(loginType.rawValue, for: .normal)
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false
            else { return }
        
        let user = User(username: username, password: password)
        
        viewModel.submit(with: user, forLoginType: loginType) { loginResult in
            DispatchQueue.main.async {
                let alert: UIAlertController
                let action: () -> Void
                
                switch loginResult {
                case .signUpSucess:
                    alert = self.alert(title: "Success", message: loginResult.rawValue)
                    action = {
                        self.present(alert, animated: true)
                        self.signUpLogInSegmentedControl.selectedSegmentIndex = 1
                        self.signUpLogInSegmentedControl.sendActions(for: .valueChanged)
                    }
                case .signInSuccess:
                    action = { self.dismiss(animated: true) }
                case .signUpError, .signInError:
                    alert = self.alert(title: "Error", message: loginResult.rawValue)
                    action = { self.present(alert, animated: true) }
                }
                action()
            }
        }
    }
    
    private func alert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    
}
