//
//  ImageGalleryDocument.swift
//  Assignment 6
//
//  Created by Mert Arıcan on 6.05.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class ImageGalleryDocument: UIDocument {
    
    var imageGallery: ImageGallery?
    
    override func contents(forType typeName: String) throws -> Any {
        return imageGallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            imageGallery = ImageGallery(json: json)
        }
    }
    
}
