//
//  ViewController.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mainView: MainView! {
        didSet {
            mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:))))
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(deal3MoreCards))
            swipeGesture.direction = .down
            mainView.addGestureRecognizer(swipeGesture)
            mainView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(mixCards)))
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var moreCardsButton: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!

    var game = GameOfSet()
    
    var cardsOnScreen : [CardView] { return mainView.cardViews }
    
    var selectedCards: [CardView] {
        return cardsOnScreen.filter { return game.selectedCards.contains($0.card) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.layoutView()
    }
    
    @objc func touchCard(sender: UITapGestureRecognizer) {
        if let cardView = sender.view as? CardView {
            switch sender.state {
            case .ended:
                game.selectCard(card: cardView.card)
            default : break
            }
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        if mainView.cardsOnTheTable.hasDifferentElement(than: game.cardsOnTheTable) {
            mainView.cardsOnTheTable = game.cardsOnTheTable ; getTapGestureForCards()
        }
        cardsOnScreen.forEach { $0.isSelected = (game.selectedCards.contains($0.card)) ? true : false }
        showSetState() ; scoreLabel?.text = "Score: \(game.score)" ; moreCardsButton?.isEnabled = true
        if !(game.deck.cards.count > 0) && !game.isSet() { moreCardsButton.isEnabled = false }
    }
    
    func getTapGestureForCards() {
        mainView.cardViews.forEach {
            guard $0.gestureRecognizers == nil else { return }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:)))
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBAction func deal3MoreCards(_ sender: Any) {
        if let sender = sender as? UISwipeGestureRecognizer {
            switch sender.state {
            case .ended:
                game.deal3MoreCards() ; updateViewFromModel()
            default: break
            }
        } else {
            game.deal3MoreCards() ; updateViewFromModel()
        }
    }
    
    func showSetState() {
        guard game.selectedCards.count == 3 else { return }
        selectedCards.forEach { $0.isSet = game.isSet() }
    }

    @IBAction func newGame(_ sender: UIButton) {
        game = GameOfSet() ; mainView.cardsOnTheTable = [] ; updateViewFromModel()
    }
    
    @objc func mixCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.mixCards() ; mainView.cardsOnTheTable = game.cardsOnTheTable; mainView.mixCards()
        default: break
        }
    }
    
}
