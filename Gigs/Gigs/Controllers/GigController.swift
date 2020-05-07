//
//  GigController.swift
//  Gigs
//
//  Created by Dahna on 5/5/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation

class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken, tryAgain, badEncode
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    var gigs: [Gig] = []
    var bearer: Bearer?
    
    let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var signInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var allGigsURL = baseURL.appendingPathComponent("/gigs/")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    //Sign Up Function
    func signUp(with user: User, completion: @escaping CompletionHandler) {
        print("signUpURL = \(signUpURL.absoluteString)")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print ("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                completion(.success(true))
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    func signIn(with user: User, completion: @escaping CompletionHandler) {
        print("signInURL = \(signInURL.absoluteString)")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print ("Sign up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                
                guard let data = data else {
                    print("No data received during sign in")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                } catch {
                    print("Error decoding bearer object: \(error)")
                    completion(.failure(.noToken))
                }
                completion(.success(true))
                print("\(self.bearer)")
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignIn))
        }
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            print("No bearer")
            completion(.failure(.noToken))
            return
        }
        var request = URLRequest(url: allGigsURL)
        print("allGigsURL = \(request)")
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error receiving gig data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.tryAgain))
                print("bad status code")
                return
            }
            guard let data = data else {
                print("No data received from fetchAllGigs")
                completion(.failure(.noData))
                return
            }
            
            do {
                self.jsonDecoder.dateDecodingStrategy = .secondsSince1970
                let allGigs = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(allGigs))
                self.gigs = allGigs
                print("fetched: \(allGigs)")
            } catch {
                print("Error decoding gig data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
        print("task has been resumed")
    }
    
    func postGig(with gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error encoding new gig: \(error)")
                    completion(.failure(.tryAgain))
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                        print("Post was unsuccessful, server status code = \(response.statusCode)")
                    completion(.failure(.failedSignIn))
                    return
                }
                completion(.success(true))
                self.gigs.append(gig)
            }
            task.resume()
        } catch {
            print("Error encoding gig: \(error)")
            completion(.failure(.badEncode))
        }
    }
    
}
