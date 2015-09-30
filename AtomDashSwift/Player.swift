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
    
    var lastTouch: CGPoint!
    var deltaPosition: CGPoint!
    
    override init() {
        
        super.init()
        
        self.name = "Player"
        
        let mutablePath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(mutablePath, nil, 0, 0, CGFloat(35 * PlayScene().getScreenWidthRatio()), CGFloat(0), CGFloat(M_PI*2), true)
        self.path = mutablePath
        self.lineWidth = 8 * PlayScene().getScreenWidthRatio()
        self.strokeColor = UIColor.gameBlueColor()
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = true
        
        self.physicsBody!.categoryBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.enemyCollider.rawValue | ColliderObject.targetCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.wallCollider.rawValue
        
        lastTouch = CGPoint()
        deltaPosition = CGPoint()
    }
    
    func startDrag(locationOfTouch: CGPoint){
        lastTouch = locationOfTouch
    }
    
    func updatePositionForDragMovement(locationOfTouch: CGPoint){
        
        let currentTouch:CGPoint = locationOfTouch
        
        deltaPosition.x = currentTouch.x - lastTouch.x
        deltaPosition.y = currentTouch.y - lastTouch.y
        
        self.position.x += deltaPosition.x
        self.position.y += deltaPosition.y
        
        lastTouch = currentTouch
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}