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
    
    var gameViewControllerObject: GameViewController?
    
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
        
        //Enemy instantiation
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("addEnemy"), userInfo: nil, repeats: true)
        
        //Buffer for label's positition
        let labelBuffer: CGFloat = self.frame.width/20
        
        // Creating the TimeLabel
        timeLabel = TimeLabel()
        timeLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        timeLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        timeLabel!.position = CGPoint(x: labelBuffer, y: self.frame.maxY - labelBuffer)
        timeLabel!.fontName = "HelveticaNeue-light"
        timeLabel!.fontSize = 50
        timeLabel!.fontColor = UIColor.blackColor()
        timeLabel!.startCountdown(30)
        
        // Creating the ScoreLabel
        scoreLabel = ScoreLabel()
        scoreLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        scoreLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        scoreLabel!.position = CGPoint(x: self.frame.maxX - labelBuffer, y: self.frame.maxY - labelBuffer)
        scoreLabel!.text = "0"
        scoreLabel!.fontName =  "HelveticaNeue-light"
        scoreLabel!.fontSize = 50
        scoreLabel!.fontColor = UIColor.blackColor()
        
        self.addChild(player!)
        self.addChild(target!)
        self.addChild(timeLabel!)
        self.addChild(scoreLabel!)
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
        case ColliderObject.enemyCollider.rawValue | ColliderObject.playerCollider.rawValue:
            contact.bodyB.node!.removeFromParent()
            scoreLabel!.removeScore(1)
        case ColliderObject.targetCollider.rawValue | ColliderObject.playerCollider.rawValue:
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
            //gameViewControllerObject?.presentGameOverViewController()
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
        target!.moveToRandomPosition(self.frame)
    }
}













