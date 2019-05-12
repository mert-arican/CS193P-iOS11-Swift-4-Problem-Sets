//
//  ImageGallery.swift
//  Assignment 6
//
//  Created by Mert Arıcan on 6.05.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

struct ImageGallery: Codable {
    
    var urls = [URL]()
    
    var aspectRatios = [String:Float]()
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(urls: [URL], ratios: [String:Float]) {
        self.urls = urls
        self.aspectRatios = ratios
    }
    
}
