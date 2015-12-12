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
    
    //var lastTouch: CGPoint!
    //var deltaPosition: CGPoint!
    
    public var cost: Int?
    
    override init() {
        super.init()
        
        createPlayer(UIColor.gameBlueColor(), name: "DefaultPlayer")
    }
    
    init(color: UIColor!, name: String!, playerCost: Int!) {
        super.init()
        
        self.cost = playerCost
        createPlayer(color, name: name)
    }
    
    func createPlayer(color: UIColor, name: String) {
        self.name = name
        
        let mutablePath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(mutablePath, nil, 0, 0, CGFloat(35 * Screen.screenWidthRatio), CGFloat(0), CGFloat(M_PI*2), true)
        self.path = mutablePath
        self.lineWidth = 8 * Screen.screenWidthRatio
        self.strokeColor = color
        
        print("Hello \(Screen.screenWidthRatio)")
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = true
        
        self.physicsBody!.categoryBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.enemyCollider.rawValue | ColliderObject.targetCollider.rawValue | ColliderObject.coinCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.wallCollider.rawValue
        
        //lastTouch = CGPoint()
        //deltaPosition = CGPoint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}