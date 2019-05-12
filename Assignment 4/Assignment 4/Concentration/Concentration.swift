//
//  Concentration.swift
//  Lecture 2
//
//  Created by Mert Arıcan on 17.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    var flipCount = 0
    
    var score = 0
    
    func chooseCard(at index: Int) {
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                var match = false
                if cards[matchIndex].identifier == cards[index].identifier {
                    // MATCH
                    match = true
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
                updateScore(indexes: [index, matchIndex], match: match)
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        var shuffledCards = [Card]()
        while cards.count > 0 {
            shuffledCards.append(cards.remove(at: Int.random(in: cards.indices)))
        }
        cards = shuffledCards
    }
    
    var mismatchDictionary = [Int:Int]()
    
    func updateScore(indexes: [Int], match: Bool) {
        if !match {
            for index in indexes {
                if mismatchDictionary[index] != nil { score -= 1 }
                else { mismatchDictionary[index] = 1 }
            }
        } else { score += 2 }
    }
    
    
}
