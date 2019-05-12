//
//  Card.swift
//  Lecture 2
//
//  Created by Mert Arıcan on 17.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

struct Card {
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
 
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    
}
