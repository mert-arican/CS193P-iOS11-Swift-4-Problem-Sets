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

class ImageCollectionViewCell: UICollectionViewCell, URLSessionTaskDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: ImageCollectionViewCellDelegate?
    
    private static var cache = URLCache(memoryCapacity: 1024*1024*30, diskCapacity: 1024*1024*30, diskPath: nil)
    
    var session = URLSession(configuration: .default)
    
    var url: URL! {
        didSet {
            let request = URLRequest(url: url.imageURL)
            if let cachedResponse = ImageCollectionViewCell.cache.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
                self.imageView.image = image ; self.activityIndicator.isHidden = true
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    let task = self.session.dataTask(with: request, completionHandler: { (newData, newResponse, error) in
                        DispatchQueue.main.async {
                            if error != nil { self.delegate?.imageDropFailed(self) }
                            if let data = newData, let image = UIImage(data: data) {
                                if let response = newResponse {
                                    ImageCollectionViewCell.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                                }
                                self.imageView.image = image
                                self.activityIndicator.isHidden = true
                            }
                        }
                    })
                    task.resume()
                }
            }
        }
    }
    
}
