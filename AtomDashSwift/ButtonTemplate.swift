//
//  ButtonTemplate .swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/16/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonTemplate: SKShapeNode {
    
    init(name: String, labelName: String, size: CGSize, position: CGPoint, color: UIColor) {
        super.init()
        
        let rect = CGRect(origin: CGPointZero, size: size)
        self.path = CGPathCreateWithRoundedRect(rect, CGFloat(10), CGFloat(10), nil)
        
        self.name = name
        self.position.x = position.x - self.frame.width/2
        self.position.y = position.y - self.frame.height/2
        self.zPosition = 2
        self.fillColor = color
        self.alpha = 1
        
        let buttonLabel = SKLabelNode(text: labelName)
        buttonLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4)
        buttonLabel.fontName = "DINCondensed-Bold"
        buttonLabel.fontSize = 35
        buttonLabel.color = UIColor.clearColor()
        buttonLabel.name = name
        self.addChild(buttonLabel)        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
