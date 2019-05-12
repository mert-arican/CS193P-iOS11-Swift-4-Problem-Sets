//
//  CardViewExtensions.swift
//  Assignment 4
//
//  Created by Mert Arıcan on 11.05.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

extension CardView {
    
    private func getDrawingPoints(numberOfObjects: CGFloat) -> [CGPoint] {
        let totalWidth = (width*numberOfObjects*Ratios.objectWidthRatio*2)+((numberOfObjects-1) * (width*Ratios.verticalOffSetRatio))
        let x = (width - totalWidth) / 2
        var array = [CGPoint]()
        for index in 0..<Int(numberOfObjects) {
            let positionX = x + (CGFloat(index) * ((2*Ratios.objectWidthRatio*width))) + ((CGFloat(index)*width*Ratios.verticalOffSetRatio))
            array.append(CGPoint(x: positionX, y: self.bounds.midY))
        }
        return array
    }
    
    func draw(the card: GameOfSetCard) -> UIBezierPath {
        var path = UIBezierPath()
        let points = getDrawingPoints(numberOfObjects: CGFloat(card.number.rawValue))
        
        switch card.color {
        case .green :
            UIColor.green.setStroke() ; UIColor.green.setFill()
        case .purple:
            UIColor.purple.setStroke() ; UIColor.purple.setFill()
        case .red:
            UIColor.red.setStroke() ; UIColor.red.setFill()
        }
        
        switch card.shape {
        case .diamond:
            path = drawObject(method: drawDiamond(at: ), points: points)
        case .oval:
            path = drawObject(method: drawRoundedRect(at: ), points: points)
        case .squiggles:
            path = drawObject(method: drawSquiggle(at:), points: points)
        }
        
        switch card.shading {
        case .open:
            break
        case.solid:
            path.fill()
        case .striped:
            path.addClip()
            drawStripes(at: path)
        }
        
        path.stroke()
        selectionState()
        return path
    }
    
    func drawObject(method:(CGPoint) -> UIBezierPath, points: [CGPoint]) -> UIBezierPath {
        let paths = points.compactMap({ (point) -> UIBezierPath in method(point) })
        let card = UIBezierPath()
        paths.forEach { card.append($0) }
        return card
    }
    
    private func drawDiamond(at point: CGPoint) -> UIBezierPath {
        let objectWidth = width * Ratios.objectWidthRatio
        let objectHeight = height * Ratios.objectHeightRatio
        let x2 = point.x + objectWidth ; let y2 = point.y - objectHeight
        let x3 = point.x + 2 * objectWidth ; let y3 = point.y
        let x4 = x2 ; let y4 = point.y + objectHeight
        let diamond = UIBezierPath()
        diamond.move(to: point)
        diamond.addLine(to: CGPoint(x: x2, y: y2))
        diamond.addLine(to: CGPoint(x: x3, y: y3))
        diamond.addLine(to: CGPoint(x: x4, y: y4))
        diamond.close()
        return diamond
    }
    
    func drawSquiggle(at point: CGPoint) -> UIBezierPath {
        let t1 = CGPoint(x: point.x, y: point.y - (8*Ratios.k*height))
        let c1 = CGPoint(x: point.x - (1.5*Ratios.k*width) + (width*Ratios.objectWidthRatio), y: point.y - (4*Ratios.k*height))
        let c2 = CGPoint(x: c1.x, y: point.y)
        let t2 = CGPoint(x: point.x, y: point.y + 10*Ratios.k*height)
        let t3 = CGPoint(x: point.x+(2*Ratios.objectWidthRatio*width), y: t2.y)
        let c3 = CGPoint(x: point.x + (Ratios.objectWidthRatio*width), y: point.y + (Ratios.objectHeightRatio*height))
        let c4 = CGPoint(x: point.x + (1.5*Ratios.k*width) + (width*Ratios.objectWidthRatio), y: point.y + (4*Ratios.k*height))
        let c5 = CGPoint(x: c4.x, y: point.y)
        let t4 = CGPoint(x: point.x + (2*width*Ratios.objectWidthRatio), y: point.y - (8*Ratios.k*height))
        let c6 = CGPoint(x: c3.x, y: point.y - (Ratios.objectHeightRatio*height))
        let path = UIBezierPath()
        path.move(to: t1)
        path.addCurve(to: t2, controlPoint1: c1, controlPoint2: c2)
        path.addQuadCurve(to: t3, controlPoint: c3)
        path.addCurve(to: t4, controlPoint1: c4, controlPoint2: c5)
        path.addQuadCurve(to: t1, controlPoint: c6)
        return path
    }
    
    func drawRoundedRect(at point: CGPoint) -> UIBezierPath {
        let rect = UIBezierPath(roundedRect: CGRect(x: point.x, y: point.y-(height*Ratios.objectHeightRatio), width: width*2*Ratios.objectWidthRatio, height: height*2*Ratios.objectHeightRatio), cornerRadius: 50.0)
        return rect
    }
    
    func drawStripes(at object: UIBezierPath) {
        let k = self.bounds.height / 20
        let x = self.bounds.minX ; let y = self.bounds.minY
        for index in 0..<20 {
            object.move(to: CGPoint(x: x, y: y + (CGFloat(index)*k) ) )
            object.addLine(to: CGPoint(x: x + (bounds.width), y: y + (CGFloat(index)*k) ) )
        }
    }
    
    func initialMoveCard(to:CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.frame = to
        }, completion: { (position) in
            guard !self.isFaceUp else { return }
            UIView.transition(with: self, duration: 1.0, options: [.transitionFlipFromLeft], animations: {
                self.isFaceUp = true
            }, completion: nil)
        })
    }
    
    func moveCard(to: CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.frame = to
        })
    }
    
    func flipCard() {
        UIView.transition(with: self, duration: 0.75, options: [.transitionFlipFromLeft], animations: {
            self.isFaceUp = !self.isFaceUp
        })
    }
    
}

private struct Ratios {
    static let verticalOffSetRatio: CGFloat = 0.1093
    static let objectWidthRatio: CGFloat = 0.0937
    static let objectHeightRatio: CGFloat = 0.4
    static let k: CGFloat = 0.0208
}
