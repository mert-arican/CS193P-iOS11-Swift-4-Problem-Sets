//
//  ViewController.swift
//  Concentration
//
//  Created by Mert Arıcan on 16.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        chooseRandomTheme()
        // Do any additional setup after loading the view.
    }
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    func updateLabels() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        chooseRandomTheme()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!

    var cardColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var emojiThemes = ["Animals":["🦆","🦐","🦑","🐪","🦜","🦓","🐘","🦉"],
                        "Food": ["🍔","🍫","🍳","🌽","🍆","🥔","🍮","🍛"],
                        "Moon":["🌒","🌖","🌗","🌑","🌘","🌕","🌔","🌒"],
                        "Green":["🌲","🌳","🌴","🌿","☘️","🍀","🌵","🌱"],
                        "Athlete":["🤼‍♂️","🤼‍♀️","🤸🏻‍♂️","🤸🏻‍♀️","🤽🏼‍♀️","🤽🏼‍♂️","🧗🏻‍♂️","🧗🏻‍♀️"],
                        "Faces":["🤓","😎","🧐","😆","😏","😭","🤩","🥳"]
                        ]
    
    var emojiChoices : [String] = []
    
    func chooseRandomTheme() {
        emojiChoices = []
        if let key = emojiThemes.keys.randomElement() {
            if let choices = emojiThemes[key] { emojiChoices = choices }
            emojiThemes.removeValue(forKey: key)
            switch key {
            case "Animals":
                cardColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) ; view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case "Food":
                cardColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) ; view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case "Moon":
                cardColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) ; view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "Green":
                cardColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) ; view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case "Athlete":
                cardColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1) ; view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            case "Faces":
                cardColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) ; view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            default:
                break
            }
        }
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else { print("Chosen card was not in cardButtons") }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardColor
            }
        }
        updateLabels()
    }
    
    var emoji = Dictionary<Int, String>()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int.random(in: 0..<emojiChoices.count)
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }

    
}

