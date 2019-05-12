//
//  GameOfSet.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

class GameOfSet {
    
    var deck = GameOfSetCardDeck()
    
    var cardsOnTheTable = [GameOfSetCard]()
    
    var selectedCards = [GameOfSetCard]()
    
    var score = 0
    
    init() {
        for _ in 1...12 { if let card = deck.draw() { cardsOnTheTable.append(card) } }
    }
    
    func deal3MoreCards() {
        if isSet() {
            if deck.cards.count > 0 {
                selectedCards.forEach { cardsOnTheTable.replace(this: $0, with: deck.draw()!) }
            } else {
                selectedCards.forEach { _ = cardsOnTheTable.removeElement(element: $0) }
            }
            selectedCards = [] ; score += 3
        } else {
            if deck.cards.count > 0 {
                for _ in 1...3 { cardsOnTheTable.append(deck.draw()!) }
            }
            if selectedCards.count == 3 { selectedCards = [] ; score -= 5 }
        }
    }
    
    func selectCard(card: GameOfSetCard) {
        if selectedCards.count == 3 {
            guard !(isSet() && selectedCards.contains(card)) else { return }
            if isSet() { deal3MoreCards() }
            selectedCards = [card]
        } else {
            if !selectedCards.contains(card) { selectedCards.append(card) } else {
                _ = selectedCards.removeElement(element: card) ; score -= 1
            }
        }
    }
        
    func isSet() -> Bool {
        /* Create a list with selectedCards' rawValues. Make element wise addition.
         If every element in the result can be divided by 3 then return true else return false.
         */
        guard selectedCards.count == 3 else { return false }
        var list = selectedCards.compactMap { (card) -> [Int]? in card.rawValues }
        let result = zip(zip(list[0], list[1]).map(+), list[2]).map(+)
        var isSet = true ; result.forEach { if $0 % 3 != 0 { isSet = false } }
        return isSet
    }
    
    func mixCards() {
        for _ in 0..<cardsOnTheTable.count {
            cardsOnTheTable.swapAt(cardsOnTheTable.randomElementIndex, cardsOnTheTable.randomElementIndex)
        }
    }
    
}
