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

    func getGrid() -> Grid { return Grid(layout: .aspectRatio(8/5), frame: bounds) }

    func initializeCards() {
        grid.cellCount = cardsOnTheTable.count
        for index in 0..<cardsOnTheTable.count {
            addCard(at: grid[index]! , card: cardsOnTheTable[index])
        }
    }
    
    func addCard(at here: CGRect, card: GameOfSetCard) {
        let cardView = CardView(frame: here)
        cardView.card = card ; cardView.layer.borderWidth = 3.0 ; cardView.layer.cornerRadius = 9.0
        cardView.backgroundColor = UIColor.white
        cardViews.append(cardView)
        self.addSubview(cardView)
    }
    
    func removeCards(cards: [GameOfSetCard]) {
        var removeList = [CardView]()
        for index in 0..<cardViews.count { if cards.contains(cardViews[index].card) { cardViews[index].removeFromSuperview() ; removeList.append(cardViews[index])} }
        removeList.forEach { _ = cardViews.removeElement(element: $0) }
    }
    
    func updateCardViews() {
         /* If there are no difference in cards then do nothing.
            If there no cards on screen then initialise main view.
            /*  If there are more cards in deck than view then add them to view.
                Else if there are more card views than cards in deck then remove cards from view.
                Else replace matched cards with new ones. */
         */
        guard cardsOnScreen.hasDifferentElement(than: cardsOnTheTable) else { return }
        guard cardViews != [] else { initializeCards() ; return }
        let cardsToRemove = cardsOnScreen.filter { return !cardsOnTheTable.contains($0) }
        let cardsToAdd = cardsOnTheTable.filter { return !cardsOnScreen.contains($0) }
        if cardsOnTheTable.count > cardViews.count {
            grid.cellCount = cardsOnTheTable.count ; updateFrames() ; let placeToAdd = [grid[cardsOnTheTable.endIndex-3], grid[cardsOnTheTable.endIndex-2], grid[cardsOnTheTable.endIndex-1]]
            for index in 0...2 { addCard(at: placeToAdd[index]!, card: cardsToAdd[index]) }
        } else if cardsOnScreen.count > cardsOnTheTable.count {
            grid.cellCount = cardsOnTheTable.count ; removeCards(cards: cardsToRemove) ; updateFrames()
        } else {
            let emptyPlaces = cardsToRemove.compactMap { (card) -> CGRect? in
                cardViews[cardsOnScreen.firstIndex(of: card)!].frame
            }
            for index in 0...2 { addCard(at: emptyPlaces[index], card: cardsToAdd[index]) }
            removeCards(cards: cardsToRemove)
        }
    }
    
    func mixCards() {
        // cardsOnTheTable already mixed before this function executes so all it does is it syncs cardViews with cardsOnTheTable.
        cardViews = cardViews.sorted(by: { cardsOnTheTable.firstIndex(of: $0.card)! < cardsOnTheTable.firstIndex(of: $1.card)! })
        updateFrames()
    }
    
    func layoutView() {
        guard grid.frame != bounds else { return }
        updateFrames()
    }
    
    func updateFrames() {
        grid.frame = bounds ; for index in cardViews.indices { cardViews[index].frame = grid[index]! }
    }
    
}
