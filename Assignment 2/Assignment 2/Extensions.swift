//
//  Extensions.swift
//  Assignment 2
//
//  Created by Mert Arıcan on 11.05.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

extension Array where Element: AdditiveArithmetic {
    func elementWiseAddition(with:Array) -> Array? {
        guard with.count == self.count else { return nil }
        var result = [Element]()
        for index in self.indices { result.append(with[index] + self[index]) }
        return result
    }
}

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
