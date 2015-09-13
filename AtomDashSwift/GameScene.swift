//
//  GameScene.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKNode?
    var enemy: SKNode?
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody!.categoryBitMask = ColliderObject.wallCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.playerCollider.rawValue
        
        player = Player()
        player!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(player!)
        self.addChild(enemy!)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)

            player!.moveToPosition(location, moveType: MoveType.Direct)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case ColliderObject.wallCollider.rawValue | ColliderObject.playerCollider.rawValue:
            println("wall and player")
        case ColliderObject.enemyCollider.rawValue | ColliderObject.playerCollider.rawValue:
            println("player and enemy")
        case ColliderObject.targetCollider.rawValue | ColliderObject.playerCollider.rawValue:
            println("player and target")
        default:
            println("default collision")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
