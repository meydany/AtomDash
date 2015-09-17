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
    
    var pauseButton: SKNode?
    
    var resumeButton: SKShapeNode?
    var resumeLabel: SKLabelNode?
    
    var exitButton: SKShapeNode?
    var exitLabel: SKLabelNode?
    
    var restartButton: SKShapeNode?
    var restartLabel: SKLabelNode?
    
    var backgroundFilterNode: SKSpriteNode?
    
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
        
        // Creating enemies
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
        
        // Creating a pause button
        pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        pauseButton?.xScale = 1
        pauseButton?.yScale = 1
        pauseButton?.position.x = self.frame.minX + (pauseButton!.frame.width/2)
        pauseButton?.position.y = self.frame.minY + (pauseButton!.frame.height/2)
        pauseButton?.name = "PauseButton"
        pauseButton?.userInteractionEnabled = false
        
        resumeButton = SKShapeNode(rectOfSize: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), cornerRadius: CGFloat(10))
        resumeButton!.position = CGPoint(x: self.frame.midX, y: (3*self.frame.height)/5)
        resumeButton!.zPosition = 2
        resumeButton!.fillColor = UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1)
        resumeButton!.name = "ResumeButton"
        
        resumeLabel = SKLabelNode(text: "Resume")
        resumeLabel!.position = CGPoint(x: 0, y: -resumeButton!.frame.height/4)
        resumeLabel!.fontName = "DINCondensed-Bold"
        resumeLabel!.fontSize = 35
        resumeLabel!.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        resumeLabel!.name = "ResumeButton"
        resumeButton!.addChild(resumeLabel!)
        
        exitButton = SKShapeNode(rectOfSize: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), cornerRadius: CGFloat(10))
        exitButton!.position = CGPoint(x: self.frame.midX, y: (2*self.frame.height)/5)
        exitButton!.zPosition = 2
        exitButton!.fillColor = UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1)
        exitButton!.name = "ExitButton"
        
        exitLabel = SKLabelNode(text: "Exit")
        exitLabel!.position = CGPoint(x: 0, y: -resumeButton!.frame.height/4)
        exitLabel!.fontName = "DINCondensed-Bold"
        exitLabel!.fontSize = 35
        exitLabel!.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        exitLabel!.name = "ExitButton"
        exitButton!.addChild(exitLabel!)
        
        restartButton = SKShapeNode(rectOfSize: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), cornerRadius: CGFloat(10))
        restartButton!.position = CGPoint(x: self.frame.midX, y: (2.5*self.frame.height)/5)
        restartButton!.zPosition = 2
        restartButton!.fillColor = UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1)
        restartButton!.name = "RestartButton"
        
        restartLabel = SKLabelNode(text: "Restart")
        restartLabel!.position = CGPoint(x: 0, y: -resumeButton!.frame.height/4)
        restartLabel!.fontName = "DINCondensed-Bold"
        restartLabel!.fontSize = 35
        restartLabel!.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        restartLabel!.name = "RestartButton"
        restartButton!.addChild(restartLabel!)
        
        self.addChild(pauseButton!)
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
            
            if (self.nodeAtPoint(location).name == "PauseButton"){
                if(!scene!.paused) {
                    scene!.paused = true
                    
                    applyFilter()
                    self.addChild(resumeButton!)
                    self.addChild(exitButton!)
                    self.addChild(restartButton!)
                }
            }else if (self.nodeAtPoint(location).name == "ResumeButton"){
                if(scene!.paused) {
                    scene!.paused = false
                    
                    removeFilter()
                    resumeButton!.removeFromParent()
                }
            }else if (self.nodeAtPoint(location).name == "ExitButton"){
                if(scene!.paused) {
                    var menuScene = MenuScene(size: self.scene!.size)
                    self.scene!.view?.presentScene(menuScene)
                }
            }else if (self.nodeAtPoint(location).name == "RestartButton"){
                if(scene!.paused) {
                    var playScene = PlayScene(size: self.scene!.size)
                    self.scene!.view?.presentScene(playScene)
                }
            }
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
    
    func applyFilter() {
        backgroundFilterNode = SKSpriteNode(color: UIColor.whiteColor(), size: self.view!.frame.size)
        backgroundFilterNode!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundFilterNode!.zPosition = self.scene!.zPosition + 1
        backgroundFilterNode!.alpha = 0.75
        
        self.addChild(backgroundFilterNode!)
    }
    
    func removeFilter() {
        backgroundFilterNode!.removeFromParent()
    }
}













