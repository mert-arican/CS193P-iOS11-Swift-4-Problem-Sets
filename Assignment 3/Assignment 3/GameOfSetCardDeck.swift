//
//  GameOfSetCardDeck.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

struct GameOfSetCardDeck {
    
    var cards = [GameOfSetCard]()
    
    init() {
        for shape in GameOfSetCard.Shape.all {
            for number in GameOfSetCard.Number.all {
                for colors in GameOfSetCard.Color.all {
                    for shading in GameOfSetCard.Shading.all {
                        cards.append(GameOfSetCard(shape: shape, number: number, color: colors, shading: shading))
                    }
                }
            }
        }
    }
    
    mutating func draw() -> GameOfSetCard? {
        return (cards.count > 0) ? cards.randomElement() : nil
    }
    
}

