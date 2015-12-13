//
//  Player.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class ImagePlayer : SKSpriteNode {
    
    //var lastTouch: CGPoint!
    //var deltaPosition: CGPoint!
    
    public var cost: Int?
    
    init(image: String!, name: String!, playerCost: Int!) {
        super.init(texture: SKTexture(imageNamed: name), color: UIColor.blackColor(), size: SKTexture(imageNamed: image).size())
        self.cost = playerCost
        
        let scale = Screen.screenWidthRatio
        //(Player().frame.width / self.frame.width)
        self.xScale = scale
        self.yScale = scale
        createPlayer(name)

    }
    
    func createPlayer(name: String) {
        self.name = name
        
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