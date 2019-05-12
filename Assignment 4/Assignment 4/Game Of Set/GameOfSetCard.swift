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
 
    var shape: Shape
    var number: Number
    var color: Color
    var shading: Shading
    
    var rawValues: [Int] { return [shape.rawValue, number.rawValue, color.rawValue, shading.rawValue] }
    
    enum Shape: Int, CustomStringConvertible {
        case diamond = 1
        case oval
        case squiggles

        var description: String { return "\(rawValue)" }

        static var all: [Shape] { return [.diamond, .oval, .squiggles] }
    }
    
    enum Number: Int, CustomStringConvertible {
        case one = 1
        case two
        case three
        
        var description: String { return "\(rawValue)" }
        
        static var all: [Number] { return [.one, .two, .three] }
    }
    
    enum Color: Int, CustomStringConvertible {
        case red = 1
        case green
        case purple
        
        var description: String { return "\(rawValue)" }

        static var all: [Color] { return [.green, .purple, .red] }
    }
    
    enum Shading: Int, CustomStringConvertible {
        case open = 1
        case striped
        case solid
        
        var description: String { return "\(rawValue)" }

        static var all: [Shading] { return [.open, .striped, .solid] }
    }
    
}
