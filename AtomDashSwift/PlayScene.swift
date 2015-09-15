//
//  GameScene.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import Darwin

enum ColliderObject: UInt32 {
    case wallCollider = 1
    case playerCollider = 2
    case targetCollider = 4
    case enemyCollider = 8
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player?
    var enemy: Enemy?
    var target: Target?
    
    var scoreLabel: ScoreLabel?
    var timeLabel: TimeLabel?
    
    var newTarget: Bool?
    
    var timer: NSTimer?
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody!.categoryBitMask = ColliderObject.wallCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.playerCollider.rawValue
        
        //Player instantiation
        player = Player()
        player!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //Target instantiation
        target = Target()
        target!.moveToRandomPosition(self.frame)
        newTarget = false
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.5),SKAction.runBlock(addEnemy)])))
        
        //Buffer for label's positition
        let labelBuffer: CGFloat = self.frame.width/20
        
        // Creating the TimeLabel
        timeLabel = TimeLabel()
        timeLabel!.position = CGPoint(x: labelBuffer, y: self.frame.maxY - labelBuffer)
        timeLabel!.startCountdown(10)
        
        // Creating the ScoreLabel
        scoreLabel = ScoreLabel()
        scoreLabel!.position = CGPoint(x: self.frame.maxX - labelBuffer, y: self.frame.maxY - labelBuffer)

        self.addChild(player!)
        self.addChild(target!)
        self.addChild(timeLabel!)
        self.addChild(scoreLabel!)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)

            player!.moveToPosition(location, moveType: MoveType.Smooth)
            //scene!.paused = !scene!.paused
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case ColliderObject.enemyCollider.rawValue | ColliderObject.playerCollider.rawValue:
            contact.bodyB.node!.removeFromParent()
            scoreLabel!.removeScore(1)
        case ColliderObject.targetCollider.rawValue | ColliderObject.playerCollider.rawValue:
            contact.bodyB.node!.removeFromParent()
            newTarget = true
        default:
            println("Default collision")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if(newTarget!) {
            createNewTarget()
            scoreLabel!.addScore(1)
            
            newTarget = false
        }
        
        if (timeLabel!.isTimeUp){
            var gameOverScene = GameOverScene(score: scoreLabel!.text, size: self.scene!.size)
            self.scene!.view?.presentScene(gameOverScene)
        }
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
    
    func createNewTarget() {
        target = Target()
        target!.moveToRandomPosition(self.frame)
        
        self.addChild(target!)
    }
}













