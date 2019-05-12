//
//  ConcentrationThemeChooserViewController.swift
//  Assignment 4
//
//  Created by Mert Arıcan on 29.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var emojiThemes = ["Animals":["🦆","🦐","🦑","🐪","🦜","🦓","🐘","🦉"],
                       "Food": ["🍔","🍫","🍳","🌽","🍆","🥔","🍮","🍛"],
                       "Moon":["🌒","🌖","🌗","🌑","🌘","🌕","🌔","🌒"],
                       "Green":["🌲","🌳","🌴","🌿","☘️","🍀","🌵","🌱"],
                       "Athlete":["🤼‍♂️","🤼‍♀️","🤸🏻‍♂️","🤸🏻‍♀️","🤽🏼‍♀️","🤽🏼‍♂️","🧗🏻‍♂️","🧗🏻‍♀️"],
                       "Faces":["🤓","😎","🧐","😆","😏","😭","🤩","🥳"]
    ]
    
    @IBAction func chooseTheme(_ sender: Any) {
        if let cvc = lastSeguedConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = emojiThemes[themeName] {
                cvc.emoji = [:] ; cvc.emojiChoices = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    var lastSeguedConcentrationViewController: ConcentrationViewController?

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = emojiThemes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.emojiChoices = theme
                    lastSeguedConcentrationViewController = cvc
                }
            }
        }
    }

}
