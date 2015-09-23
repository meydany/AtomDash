//
//  Target.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit


class Target: SKShapeNode {
    
    override init() {
        
        super.init()
        
        self.name = "Target"
        
        let mutablePath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(mutablePath, nil, 0, 0, CGFloat(40 * PlayScene().getScreenWidthRatio()), CGFloat(0), CGFloat(M_PI*2), true)
        self.path = mutablePath
        self.lineWidth = 9 * PlayScene().getScreenWidthRatio()
        self.strokeColor = UIColor.gameGreenColor()
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = false
        
        self.physicsBody!.categoryBitMask = ColliderObject.targetCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
        //No need for collisionBitMask, we don't want the nodes to actually collide!
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
