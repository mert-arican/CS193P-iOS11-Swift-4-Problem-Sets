//
//  CardButton.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 20.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var card : GameOfSetCard! { didSet { setNeedsDisplay() } }
    
    var isSelected = false { didSet { selectionState() } }
    
    var isFaceUp = false { didSet { setNeedsDisplay(); setBackgroundColor() } }

    var isSet = false { didSet { setState() } }
    
    var width: CGFloat { return bounds.width }
    
    var height: CGFloat { return bounds.height }
    
    override func draw(_ rect: CGRect) {
        if let card = card { if isFaceUp { _ = draw(the: card) } }
        else { self.removeFromSuperview() }
    }
    
    func setBackgroundColor() { backgroundColor = isFaceUp ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
    
    func selectionState() { layer.borderColor = (isSelected) ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) }
    
    func setState() { layer.borderColor = (isSet) ? #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }

}


