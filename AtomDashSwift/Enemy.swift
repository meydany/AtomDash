//
//  Enemy.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

enum SpawnSide {
    case Left
    case Right
}

class Enemy: SKShapeNode {
    
    var side: SpawnSide?
    
    init(side: SpawnSide) {
        
        super.init()
        
        self.name = "Enemy"
        
        self.side = side
        
        let mutablePath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(mutablePath, nil, 0, 0, CGFloat(35 * Screen.screenWidthRatio), CGFloat(0), CGFloat(M_PI*2), true)
        self.path = mutablePath
        self.lineWidth = 8 * Screen.screenWidthRatio
        self.strokeColor = UIColor.gameRedColor()
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2.1)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = false
        
        self.physicsBody!.categoryBitMask = ColliderObject.enemyCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
        //No need for collisionBitMask, we don't want the nodes to actually collide!
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}