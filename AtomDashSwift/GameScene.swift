//
//  GameScene.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import Darwin

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKNode?
    var enemy: SKNode?
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody!.categoryBitMask = ColliderObject.wallCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.playerCollider.rawValue
        
        player = Player()
        player!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(player!)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("addEnemy"), userInfo: nil, repeats: true)
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
            contact.bodyB.node?.removeFromParent()
        case ColliderObject.targetCollider.rawValue | ColliderObject.playerCollider.rawValue:
            println("player and target")
        default:
            println("default collision")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func addEnemy(){
        var moveAction: SKAction?
        
        enemy = Enemy(side: SpawnSide.Right)
        
        if (arc4random_uniform(2) == 1){
            enemy!.position = CGPoint(x: self.frame.width + enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2)
            moveAction = SKAction.moveTo(CGPoint(x: -enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2), duration: (Double(arc4random_uniform(UInt32(6))) + 1.0))
        }
        else{
            enemy!.position = CGPoint(x: -enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2)
            moveAction = SKAction.moveTo(CGPoint(x: self.frame.width + enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2), duration: (Double(arc4random_uniform(UInt32(6))) + 1.0))
        }
        
        enemy!.runAction(moveAction!)
        self.addChild(enemy!)
    }
}













