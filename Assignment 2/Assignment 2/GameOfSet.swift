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
    
    var removedCards = [GameOfSetCard]()
    
    var score = 0
    
    init() {
        for _ in 1...12 { if let card = deck.draw() { cardsOnTheTable.append(card) } }
    }
    
    func deal3MoreCards() {
        if isMatch() {
            if deck.cards.count > 0 {
                selectedCards.forEach { cardsOnTheTable.replace(this: $0, with: deck.draw()!) }
                selectedCards = []
            } else {
                selectedCards.forEach { removedCards.append($0) }
                selectedCards = []
            }
            score += 3
        } else {
            if deck.cards.count > 0 {
                for _ in 1...3 { cardsOnTheTable.append(deck.draw()!) }
            }
            if selectedCards.count == 3 { selectedCards = [] ; score -= 5 }
        }
    }
    
    func selectCard(index: Int) {
        let card = cardsOnTheTable[index]
        if selectedCards.count == 3 {
            guard !(isMatch() && selectedCards.contains(cardsOnTheTable[index])) else { return }
            if isMatch() { deal3MoreCards() }
            selectedCards = [card]
        } else {
            if !selectedCards.contains(card) { selectedCards.append(card) } else {
                _ = selectedCards.removeElement(element: card) ; score -= 1
            }
        }
    }
    
    func isMatch() -> Bool {
        return GameOfSetCard.isSet(selectedCards: selectedCards)
    }
    
}
