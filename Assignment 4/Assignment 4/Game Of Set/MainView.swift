//
//  GridView.swift
//  Assignment 3
//
//  Created by Mert Arıcan on 23.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    lazy var grid = getGrid()
    
    var cardViews = [CardView]()
    
    var cardsOnTheTable = [GameOfSetCard]() { didSet { updateCardViews() } }
    
    var cardsOnScreen: [GameOfSetCard] {
        return cardViews.compactMap { (cardView) -> GameOfSetCard? in return cardView.card }
    }
    
    var lastlyRemoved = [CardView]()
    
    var initialFrameForCards = CGRect()
    //Frame of the card deck.
    
    var snapPoint = CGPoint()
    //Point to snap the matched cards.
    
    func getGrid() -> Grid { return Grid(layout: .aspectRatio(8/5), frame: bounds) }
    
    func initializeCards() {
        grid.cellCount = cardsOnTheTable.count
        for index in 0..<cardsOnTheTable.count {
            addCard(at: initialFrameForCards , card: cardsOnTheTable[index])
        }
    }
    
    func addCard(at here: CGRect, card: GameOfSetCard) {
        let cardView = createCard(at: here, card: card)
        cardViews.append(cardView)
    }
    
    func createCard(at here: CGRect, card: GameOfSetCard) -> CardView {
        let cardView = CardView(frame: here)
        cardView.card = card ; cardView.layer.borderWidth = 3.0 ; cardView.layer.cornerRadius = 9.0
        cardView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) ; cardView.clipsToBounds = true
        addSubview(cardView)
        return cardView
    }
    
    func removeCards(cards: [CardView]) {
        cards.forEach { _ = cardViews.removeElement(element: $0) }
    }
    
    func updateCardViews() {
        /* If there are no difference in cards then do nothing.
         If there no cards on screen then initialise main view.
         /*  If there are more cards in deck than view then add them to view.
         Else if there are more card views than cards in deck then remove cards from view.
         Else replace matched cards with new ones. */ */
        guard cardsOnScreen.hasDifferentElement(from: cardsOnTheTable) else { return }
        guard cardViews != [] else { initializeCards(); updateFrames() ; return }
        lastlyRemoved = cardViews.filter { return !cardsOnTheTable.contains($0.card) }
        let cardsToAdd = cardsOnTheTable.filter { return !cardsOnScreen.contains($0) }
        if cardsOnTheTable.count > cardViews.count && lastlyRemoved == [] {
            grid.cellCount = cardsOnTheTable.count
            for index in 0...2 { addCard(at: initialFrameForCards, card: cardsToAdd[index]) }
        } else if cardsOnScreen.count > cardsOnTheTable.count {
            grid.cellCount = cardsOnTheTable.count ; removeCards(cards: lastlyRemoved)
        } else {
            for index in 0...2 { cardViews.replace(this: lastlyRemoved[index], with: createCard(at: initialFrameForCards, card: cardsToAdd[index])) }
        }
        updateFrames()
    }
    
    func mixCards() {
        cardViews = cardViews.sorted(by: { cardsOnTheTable.firstIndex(of: $0.card)! < cardsOnTheTable.firstIndex(of: $1.card)! })
        updateFrames()
    }
        
    func layoutView() {
        guard grid.frame != bounds else { return }
        updateFrames()
    }
    
    func updateFrames() {
        grid.frame = bounds
        for index in cardViews.indices {
            if cardViews[index].isFaceUp {
                cardViews[index].moveCard(to: grid[index]!)
            } else {
                cardViews[index].initialMoveCard(to: grid[index]!)
            }
        }
    }
    
}
