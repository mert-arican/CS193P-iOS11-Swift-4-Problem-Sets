//
//  GameOfSetCard.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

struct GameOfSetCard: Equatable {
    
    static func ==(lhs: GameOfSetCard, rhs: GameOfSetCard) -> Bool {
        return lhs.shape == rhs.shape && lhs.number == rhs.number && lhs.color == rhs.color && lhs.shading == rhs.shading
    }
    
    static func isSet(selectedCards: [GameOfSetCard]) -> Bool {
        guard selectedCards.count == 3 else { return false }
        let list = selectedCards.compactMap { (card) -> [Int]? in card.rawValues }
        if let result = (list[0].elementWiseAddition(with: list[1])?.elementWiseAddition(with: list[2])) {
            var isSet = true ; result.forEach { if $0 % 3 != 0 { isSet = false } } ; return isSet
        }
        return false
    }
 
    var shape: Shape
    var number: Number
    var color: Color
    var shading: Shading
    
    var rawValues: [Int] { return [shape.rawValue, number.rawValue, color.rawValue, shading.rawValue] }
    
    enum Shape: Int {
        case triangle = 1
        case square
        case circle
        
        static var all: [Shape] { return [.triangle, .square, .circle] }
    }
    
    enum Number: Int {
        case one = 1
        case two
        case three
        
        static var all: [Number] { return [.one, .two, .three] }
    }
    
    enum Color: Int {
        case red = 1
        case green
        case purple
        
        static var all: [Color] { return [.green, .purple, .red] }
    }
    
    enum Shading: Int {
        case open = 1
        case striped
        case solid
        
        static var all: [Shading] { return [.open, .striped, .solid] }
    }
    
}
