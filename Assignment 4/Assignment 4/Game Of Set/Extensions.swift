//
//  Extensions.swift
//  Assignment 3
//
//  Created by Mert Arıcan on 23.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

extension Array {
    var randomElementIndex: Int { return Int.random(in: 0..<self.count) }
}

extension Array where Element: Equatable {
    mutating func removeElement(element: Element) -> Element? {
        if let index = self.firstIndex(of: element) { return self.remove(at: index) }
        return nil
    }
}

extension Array where Element: Equatable {
    mutating func replace(this: Element, with: Element) {
        if let index = self.firstIndex(of: this) { self[index] = with }
    }
}

extension Array where Element: Equatable {
    func hasDifferentElement(from this: Array) -> Bool {
        guard self.count == this.count else { return true }
        var isDifferent = false
        self.forEach { if !this.contains($0) { isDifferent = true } }
        return isDifferent
    }
}
