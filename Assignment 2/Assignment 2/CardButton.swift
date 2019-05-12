//
//  CardButton.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    
    var card : GameOfSetCard!
    
    var isMatch = false { didSet { showMatchState() } }
    
    var isChosen = false { didSet { getCardView() } }
    
    func getCardView() {
        var attributedString = NSAttributedString()
        var string = ""
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.strokeWidth] = 10.0
        attributes[.font] = UIFont.systemFont(ofSize: 20.0)
        
        switch card.shape {
        case .triangle: string = "▲ "
        case .square: string = "■"
        case .circle: string = "●"
        }
        
        switch card.color {
        case .red : attributes[.strokeColor] = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .green: attributes[.strokeColor] = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .purple: attributes[.strokeColor] = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        }
        
        switch card.shading {
        case .open : break
        case .striped : attributes[.foregroundColor] = (attributes[.strokeColor] as! UIColor).withAlphaComponent(0.15) ; attributes[.strokeWidth] = -1.0
        case .solid : attributes[.foregroundColor] = (attributes[.strokeColor] as! UIColor).withAlphaComponent(1.0)
        attributes[.strokeWidth] = -1.0
        }
        
        switch card.number {
        case .one: attributedString =  NSAttributedString(string: string, attributes: attributes)
        case .two: attributedString = NSAttributedString(string: string+" "+string, attributes: attributes)
        case .three: attributedString =  NSAttributedString(string: string+" "+string+" "+string, attributes: attributes)
        }
        
        self.setAttributedTitle(attributedString, for: .normal)
        self.layer.borderWidth = 3.0
        self.layer.borderColor = (self.isChosen) ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1) : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.titleLabel?.numberOfLines = 0
    }
    
    func showMatchState() {
        self.layer.borderColor = (self.isMatch) ? #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
}
