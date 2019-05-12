//
//  ImageCollectionViewCell.swift
//  Assignment 5
//
//  Created by Mert Arıcan on 30.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate: class {
    func imageDropFailed(_ sender: ImageCollectionViewCell)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: ImageCollectionViewCellDelegate?
        
    var url: URL! {
        didSet {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: self.url.imageURL) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.activityIndicator.isHidden = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.imageDropFailed(self)
                    }
                }
            }
        }
    }
    
}
