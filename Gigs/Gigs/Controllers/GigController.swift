//
//  GigController.swift
//  Gigs
//
//  Created by Dahna on 4/7/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation

final class GigController {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData
        case notSignedIn, failedFetch, badURL
    }
    
    private enum LoginStatus {
        case notLoggedIn
        case loggedIn(Bearer)
        
        static var isLoggedIn: Self {
            if let bearer = GigController.bearer {
                return loggedIn(bearer)
            } else {
                return notLoggedIn
            }
        }
    }
    
    static var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var logInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var gigsURL = baseURL.appendingPathComponent("/gigs/")
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: signUpURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) {_, response, error in
                if let error = error {
                    print("Sign up failed with error: \(error.localizedDescription)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Sign up was unsuccessful")
                        return completion(.failure(.failedSignUp))
                }
                completion(.success(true))
            }
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func logIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = postRequest(for: logInURL)
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Sign in failed with error: \(error.localizedDescription)")
                    completion(.failure(.failedSignIn))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else {
                        print("Sign in was unsuccessful")
                        return completion(.failure(.failedSignIn))
                }
                
                guard let data = data else {
                    print("Data was no received")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    print("Error decoding bearer: \(error.localizedDescription)")
                    completion(.failure(.failedSignIn))
                }
            }
            .resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
    }
    
    func getGigs(completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard case let .loggedIn(bearer) = LoginStatus.isLoggedIn else {
            return completion(.failure(.notSignedIn))
        }
        
        let request = getRequest(for: gigsURL, bearer: bearer)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch gig with error \(error.localizedDescription)")
                completion(.failure(.failedFetch))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
                else {
                    print(#file, #function, #line, "Fetch gig received bad response")
                    completion(.failure(.failedFetch))
                    return
            }
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let gig = try self.jsonDecoder.decode(Gig.self, from: data)
                completion(.success(gig))
                self.gigs.append(gig)
            } catch {
                print("Error decoding animal: \(error.localizedDescription)")
                completion(.failure(.badURL))
            }
        }
    .resume()
    }
    
    
    
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func getRequest(for url: URL, bearer: Bearer) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
