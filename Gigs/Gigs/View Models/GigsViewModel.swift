//
//  GigsViewModel.swift
//  Gigs
//
//  Created by Dahna on 4/7/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation



final class GigsViewModel {
    
    enum GetGigsResult {
        case success
        case failure(String)
    }
    
    var gigs = [Gig]()
    var shouldPresentLoginViewController: Bool {
        GigController.bearer == nil
    }
    
    private let gigController: GigController
    
    init(gigController: GigController = GigController()) {
        self.gigController = gigController
    }
    
    func getGigs(completion: @escaping (GetGigsResult) -> Void) {
        gigController.getGigs { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let gigs):
                self.gigs = [gigs]
                completion(.success)
                case .failure(_):
                completion(.failure("Unable to fetch gigs"))
                }
            }
        }
    }
}
