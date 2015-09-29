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
        self.path = CGPathCreateWithRoundedRect(rect, CGFloat(8 * PlayScene().getScreenWidthRatio()), CGFloat(8 * PlayScene().getScreenWidthRatio()), nil)
        
        self.name = name
        self.position.x = position.x - self.frame.width/2
        self.position.y = position.y - self.frame.height/2
        self.zPosition = 1
        self.fillColor = color
        self.alpha = 1
        
        let buttonLabel = SKLabelNode(text: labelName)
        buttonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        buttonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        buttonLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2.15)
        buttonLabel.fontName = "DINCondensed-Bold"
        buttonLabel.color = UIColor.clearColor()
        buttonLabel.name = name
        
        let scalingFactor = min(self.frame.width / buttonLabel.frame.width, self.frame.height / buttonLabel.frame.height)/1.25
        
        // Change the fontSize.
        buttonLabel.fontSize *= (scalingFactor)
        self.addChild(buttonLabel)        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
