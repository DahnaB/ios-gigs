//
//  Gig.swift
//  Gigs
//
//  Created by Dahna on 4/8/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation

struct Gig: Decodable, Hashable {
    let title: String
    let description: String
    let dueDate: Date
}
