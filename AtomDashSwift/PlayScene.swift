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
    
    var moveEnemyAction: SKAction?
    
    var timer: NSTimer?
    
    var pauseButton: SKNode?
    
    var resumeButton: ButtonTemplate?
    var exitButton: ButtonTemplate?
    var restartButton: ButtonTemplate?
    
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
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.75),SKAction.runBlock(addEnemy)])))
        
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
        pauseButton?.xScale = 0.9
        pauseButton?.yScale = 0.9
        pauseButton?.position.x = self.frame.minX + (pauseButton!.frame.width * 0.75)
        pauseButton?.position.y = self.frame.minY + (pauseButton!.frame.height * 0.75)
        pauseButton?.name = "PauseButton"
        
        resumeButton = ButtonTemplate(name: "ResumeButton",labelName: "RESUME",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (3*self.frame.height)/5), color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        
        exitButton = ButtonTemplate(name: "ExitButton", labelName: "EXIT", size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (2*self.frame.height)/5), color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        
        restartButton = ButtonTemplate(name: "RestartButton", labelName: "RESTART", size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        
        self.addChild(pauseButton!)
        self.addChild(player!)
        self.addChild(target!)
        self.addChild(timeLabel!)
        self.addChild(scoreLabel!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        /* Called when a touch begins */
        
        for touch in (touches) {
            let location = touch.locationInNode(self)

            player!.moveToPosition(location, moveType: MoveType.Direct)
            
            if let name = self.nodeAtPoint(location).name{
                switch name {
                case "PauseButton":
                    if(!scene!.paused) {
                        scene!.paused = true
                    
                        applyFilter()
                        self.addChild(resumeButton!)
                        self.addChild(exitButton!)
                        self.addChild(restartButton!)
                        
                    }
                    break
                case "ResumeButton":
                    if(scene!.paused) {
                        scene!.paused = false
                    
                        removeFilter()
                        resumeButton!.removeFromParent()
                        exitButton!.removeFromParent()
                        restartButton!.removeFromParent()
                    }
                    break
                case "ExitButton":
                    if(scene!.paused) {
                        let menuScene = MenuScene(size: self.scene!.size)
                        self.scene!.view?.presentScene(menuScene)
                    }
                    break
                case "RestartButton":
                    if(scene!.paused) {
                        let playScene = PlayScene(size: self.scene!.size)
                        self.scene!.view?.presentScene(playScene)
                    }
                default:
                    break
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case ColliderObject.enemyCollider.rawValue | ColliderObject.playerCollider.rawValue:
            contact.bodyB.node!.removeActionForKey("moveEnemy")
            contact.bodyB.node!.runAction(SKAction.fadeOutWithDuration(0.1), completion: {contact.bodyB.node!.removeFromParent()})
            scoreLabel!.removeScore(1)
        case ColliderObject.targetCollider.rawValue | ColliderObject.playerCollider.rawValue:
            contact.bodyB.node!.removeFromParent()
            scoreLabel!.addScore(2)
            newTarget = true
        default:
            print("Default collision", terminator: "")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if(newTarget!) {
            createNewTarget()
            
            newTarget = false
        }
        
        if (timeLabel!.isTimeUp){
            let gameOverScene = GameOverScene(score: Int(scoreLabel!.text!)!, size: self.scene!.size)
            self.scene!.view?.presentScene(gameOverScene)
        }
    }
    
    
    func addEnemy(){
        enemy = Enemy(side: SpawnSide.Right)
        
        if (arc4random_uniform(2) == 1){
            enemy!.position = CGPoint(x: self.frame.width + enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2)
            moveEnemyAction = SKAction.moveTo(CGPoint(x: -enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2), duration: (Double(arc4random_uniform(UInt32(6))) + 1.0))
        }
        else{
            enemy!.position = CGPoint(x: -enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2)
            moveEnemyAction = SKAction.moveTo(CGPoint(x: self.frame.width + enemy!.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy!.frame.height))) + enemy!.frame.height/2), duration: (Double(arc4random_uniform(UInt32(3))) + 3.0))
        }
        
        enemy!.runAction(moveEnemyAction!, withKey: "moveEnemy")
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













