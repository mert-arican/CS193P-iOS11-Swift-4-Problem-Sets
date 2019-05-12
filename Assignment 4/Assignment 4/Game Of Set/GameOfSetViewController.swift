//
//  ViewController.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class GameOfSetViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private lazy var animator = UIDynamicAnimator(referenceView: mainView)
    
    private lazy var cardBehavior = CardBehavior(in: animator)
    
    var game = GameOfSet()
    
    @IBOutlet weak var mainView: MainView! {
        didSet {
            mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:))))
            mainView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(mixCards)))
        }
    }
    
    @IBOutlet weak var moreCardsButton: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var cardViewsOnScreen : [CardView] { return mainView.cardViews }
    
    var selectedCardViews: [CardView] {
        return cardViewsOnScreen.filter { return game.selectedCards.contains($0.card) }
    }
    
    var cardViewsToRemove: [CardView] {
        return mainView.lastlyRemoved
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewFromModel()
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
        adjustInitialFrameForCards()
        if mainView.cardsOnTheTable.hasDifferentElement(from: game.cardsOnTheTable) {
            mainView.cardsOnTheTable = game.cardsOnTheTable ; getTapGestureForCards(); cardsMatchedAnimation()
        }
        cardViewsOnScreen.forEach { $0.isSelected = (game.selectedCards.contains($0.card)) ? true : false }
        showSetState() ; scoreLabel?.text = "Score: \(game.score)" ; moreCardsButton?.isEnabled = true
        if !(game.deck.cards.count > 0) && !game.isSet() { moreCardsButton.isEnabled = false }
        if game.isSet() { deal3MoreCards() }
    }
    
    func getTapGestureForCards() {
        mainView.cardViews.forEach {
            guard $0.gestureRecognizers == nil else { return }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(sender:)))
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBAction func deal3MoreCards(_ sender: Any?=nil) {
        game.deal3MoreCards() ; updateViewFromModel()
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
    
    weak var timer : Timer?
    
    func cardsMatchedAnimation() {
        guard cardViewsToRemove != [] else { return }
        cardViewsToRemove.forEach { cardBehavior.addItem($0); mainView.bringSubviewToFront($0) }
        view.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            self.adjustInitialFrameForCards()
            self.cardViewsToRemove.forEach { self.cardBehavior.removeItem($0) }
            self.moreCardsButton.alpha = 0.0
            self.cardViewsToRemove.forEach { self.cardBehavior.snap($0, snapTo: self.mainView.snapPoint) ; $0.frame = self.mainView.initialFrameForCards }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (timer) in
            self.cardViewsToRemove.forEach { $0.flipCard() }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false, block: { (timer) in
            self.moreCardsButton.alpha = 1.0
            self.cardViewsToRemove.forEach { $0.removeFromSuperview() }
            self.mainView.lastlyRemoved = []
            self.view.isUserInteractionEnabled = true
        })
    }
    
    func adjustInitialFrameForCards() {
        self.mainView.initialFrameForCards = self.moreCardsButton.convert(self.moreCardsButton.bounds, to: self.mainView)
        self.mainView.snapPoint = self.moreCardsButton.convert(CGPoint(x: self.moreCardsButton.bounds.midX, y: self.moreCardsButton.bounds.midY), to: self.mainView)
    }
    
    func showSetState() {
        guard game.selectedCards.count == 3 else { return }
        selectedCardViews.forEach { $0.isSet = game.isSet() }
    }
    
}
