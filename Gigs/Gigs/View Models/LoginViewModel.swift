//
//  LoginViewModel.swift
//  Gigs
//
//  Created by Dahna on 4/7/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation

final class LoginViewModel {
    enum LoginResult: String {
        case signUpSucess = "Sign up successful. Please log in."
        case signInSuccess
        case signUpError = "Error orcurred during sign up."
        case signInError = "Error ocurred during sign in."
    }
    
    private let gigController: GigController
    
    init(gigController: GigController = GigController()) {
        self.gigController = gigController
    }
    
    func submit(with user: User, forLoginType: LoginType, completion: @escaping (LoginResult) -> Void) {
        switch forLoginType {
        case .signUp:
            signUp(with: user, completion: completion)
        case .signIn:
            signIn(with: user, completion: completion)
        }
    }
    
    private func signUp(with user: User, completion: @escaping (LoginResult) -> Void) {
        gigController.signUp(with: user) { result in
            switch result {
            case .success(_):
                completion(.signUpSucess)
            case .failure(_):
                completion(.signUpError)
            }
        }
    }
    
    private func signIn(with user: User, completion: @escaping (LoginResult) -> Void) {
        gigController.logIn(with: user) { result in
            switch result {
            case .success(_):
                completion(.signInSuccess)
            case .failure(_):
                completion(.signInError)
            }
        }
    }
    
}
