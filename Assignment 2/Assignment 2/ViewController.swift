//
//  ViewController.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardButtons.forEach { $0.isHidden = true }
        updateViewFromModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }

    var game = GameOfSet()
    
    var score: Int { return game.score }
    
    var selectedCardButtons: [CardButton] {
        var selectedCardsList = [CardButton]()
        cardButtons[0..<game.cardsOnTheTable.count].forEach { if game.selectedCards.contains($0.card) { selectedCardsList.append($0) } }
        return selectedCardsList
    }
    
    @IBAction func selectCard(_ sender: CardButton) {
        game.selectCard(index: cardButtons.firstIndex(of: sender)!)
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in 0..<game.cardsOnTheTable.count {
            cardButtons[index].isHidden = false
        }
        for index in game.cardsOnTheTable.indices {
            let button = cardButtons[index]; button.card = game.cardsOnTheTable[index]; button.isChosen = false
            if game.removedCards.count>0 { if game.removedCards.contains(button.card) { button.isHidden = true; button.isUserInteractionEnabled = false } }
        }
        for button in selectedCardButtons { button.isChosen = true }
        showSelection() ; scoreLabel.text = "Score: \(score)" ; moreCardsButton.isEnabled = true
        if (game.cardsOnTheTable.count == 24 || game.removedCards != []) && !game.isMatch() { moreCardsButton.isEnabled = false }
    }
    
    func showSelection() {
        guard game.selectedCards.count == 3 else { return }
        for button in selectedCardButtons { button.isMatch = game.isMatch() }
    }
    
    @IBOutlet weak var moreCardsButton: UIButton!
    
    @IBOutlet var cardButtons: [CardButton]!
    
    @IBAction func deal3MoreCards(_ sender: UIButton) {
        guard game.cardsOnTheTable.count < 24 || game.isMatch() else { return }
        game.deal3MoreCards() ; updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = GameOfSet() ; updateViewFromModel() ; cardButtons.forEach { $0.isHidden = true ; $0.setAttributedTitle(NSAttributedString(), for: .normal) }
    }
    
}
