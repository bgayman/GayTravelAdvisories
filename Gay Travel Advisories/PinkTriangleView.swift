//
//  PinkTriangleView.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/30/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

class PinkTriangleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        isOpaque = false
        backgroundColor = .clear
    }
    
    var path: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: bounds.maxX, y: 0.0))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        path.close()
        
        return path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.app_pink.setFill()
        path.fill()
    }
    
    override var collisionBoundingPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -bounds.midX, y: -bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: -bounds.midY))
        path.addLine(to: CGPoint(x: 0.0, y: bounds.midY))
        path.close()
        
        return path
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }

}

final class AttentionImageView: UIImageView {
    override var collisionBoundingPath: UIBezierPath {
        let bottomInset = bounds.height * 0.04
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: -bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY - bottomInset))
        path.addLine(to: CGPoint(x: -bounds.midX, y: bounds.midY - bottomInset))
        path.close()
        
        return path
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }
}
