//
//  GalleryTableViewCell.swift
//  Assignment 5
//
//  Created by Mert Arıcan on 2.05.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

protocol GalleryTableViewCellDelegate: class {
    func cellNameChanged(_ sender: GalleryTableViewCell)
}

class GalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCell(_:)))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }
    
    @objc func touchCell(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
        default:
            break
        }
    }
    
    weak var delegate: GalleryTableViewCellDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var textField: UITextField!{
        didSet {
            textField.delegate = self
            textField.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        self.delegate?.cellNameChanged(self)
        return true
    }
    
}
