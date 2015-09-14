//
//  Player.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class Player : SKShapeNode {
    
    override init() {
        
        super.init()
        
        self.name = "Player"
        
        var mutablePath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(mutablePath, nil, 0, 0, CGFloat(35), CGFloat(0), CGFloat(M_PI*2), true)
        self.path = mutablePath
        self.lineWidth = 8;
        self.strokeColor = UIColor.blackColor()
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = true
        
        self.physicsBody!.categoryBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.enemyCollider.rawValue | ColliderObject.targetCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.wallCollider.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}