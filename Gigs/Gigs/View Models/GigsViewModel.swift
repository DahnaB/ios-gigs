//
//  GigsViewModel.swift
//  Gigs
//
//  Created by Dahna on 4/7/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation

final class GigsViewModel {
    var shouldPresentLoginViewController: Bool {
        GigController.bearer == nil
    }
    
    private let gigController: GigController
    
    init(gigController: GigController = GigController()) {
        self.gigController = gigController
    }
}
