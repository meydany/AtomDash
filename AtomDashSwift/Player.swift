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
        
        var mutablePath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(mutablePath, nil, 0, 0, CGFloat(35), CGFloat(0), CGFloat(M_PI*2), true)
        self.path = mutablePath
        self.lineWidth = 8;
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = false
        self.physicsBody!.dynamic = true
        
        self.physicsBody!.categoryBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.wallCollider.rawValue | ColliderObject.enemyCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.wallCollider.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}