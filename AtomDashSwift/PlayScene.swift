//
//  GameScene.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import Darwin
import GameKit


enum ColliderObject: UInt32 {
    case wallCollider = 1
    case playerCollider = 2
    case targetCollider = 4
    case enemyCollider = 8
    case coinCollider = 16
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var currentPlayer: Player!
    var enemy: Enemy!
    var target: Target!
    
    var scoreLabel: ScoreLabel!
    var dragLabel: SKLabelNode!
    
    var pauseButton: SKNode!
    var resumeButton: ButtonTemplate!
    var exitButton: ButtonTemplate!
    var restartButton: ButtonTemplate!
    
    var newTarget: Bool!
    
    var moveEnemyAction: SKAction!
    
    var timer: NSTimer!
    
    var backgroundFilterNode: SKSpriteNode!
    
    var initialPauseWait: Bool!
    var gameStarted: Bool!
    
    var updatesCalled: Int!
    var updateBuffer: Int!
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody!.categoryBitMask = ColliderObject.wallCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.playerCollider.rawValue
        
        //currentPlayer instantiation
        
        currentPlayer = Players().getCurrentPlayer() as! Player
        currentPlayer.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //Target instantiation
        target = Target()
        target.moveToRandomPosition(self.frame)
        newTarget = false
        
        // Creating enemies
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.6),SKAction.runBlock(addEnemy)])))
        
        //Buffer for label's positition
        let labelBuffer: CGFloat = self.frame.width/20
        
        // Creating the ScoreLabel
        scoreLabel = ScoreLabel()
        scoreLabel.position = CGPoint(x: self.frame.midX + scoreLabel.frame.width/2, y: self.frame.maxY - labelBuffer)
        
        dragLabel = SKLabelNode(text: "DRAG TO START")
        dragLabel.name = "DragLabel"
        dragLabel.fontName = "DINCondensed-Bold"
        dragLabel.fontSize = 25 * Screen.screenHeightRatio
        dragLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - currentPlayer.frame.height)
        dragLabel.fontColor = UIColor.lightGrayColor()
        
        // Creating a pause button
        pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        pauseButton.xScale = 0.5
        pauseButton.yScale = 0.5
        pauseButton.zPosition = 2
        pauseButton.position.x = self.frame.minX + (pauseButton!.frame.width)
        pauseButton.position.y = self.frame.minY + (pauseButton!.frame.height)
        pauseButton.name = "PauseButton"
        
        resumeButton = ButtonTemplate(name: "ResumeButton",labelName: "RESUME",  size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (3*self.frame.height)/5), color: UIColor.gameBlueColor())
        
        exitButton = ButtonTemplate(name: "ExitButton", labelName: "EXIT", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (2*self.frame.height)/5), color: UIColor.gameRedColor())
        
        restartButton = ButtonTemplate(name: "RestartButton", labelName: "RESTART", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor.gameGreenColor())
        
        initialPauseWait = true
        gameStarted = false
        
        updatesCalled = 0
        updateBuffer = 5 //adjust this according to performance 
        
        //createCoins()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pauseSceneOnHomePress"), name:UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pauseSceneOnActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)

        self.addChild(pauseButton)
        self.addChild(currentPlayer)
        self.addChild(target)
        self.addChild(scoreLabel)
        self.addChild(dragLabel)
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(initialPauseWait!) {
            runAction(SKAction.waitForDuration(0.1), completion: {self.scene!.paused = true})
            initialPauseWait = false
        }
        if(newTarget!) {
            createNewTarget()
            newTarget = false
        }
        
        updatesCalled!++
        // Left
        if ((currentPlayer.position.x + currentPlayer.frame.width/2) <= (view?.frame.minX)!){
            currentPlayer.position.x = (view?.frame.minX)! + currentPlayer.frame.width/2
        }
        // Right
        else if ((currentPlayer.position.x + currentPlayer.frame.width/2) >= (view?.frame.maxX)!){
            currentPlayer.position.x = (view?.frame.maxX)! - currentPlayer.frame.width/2
        }
        // Top
        else if ((currentPlayer.position.y + currentPlayer.frame.height/2) >= (view?.frame.maxY)!){
            currentPlayer.position.y = (view?.frame.maxY)! - currentPlayer.frame.height/2
            
        }
        // Bottom
        else if ((currentPlayer.position.y - currentPlayer.frame.width/2) <= (view?.frame.minY)!){
            currentPlayer.position.y = (view?.frame.minY)! + currentPlayer.frame.height/2
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        /* Called when a touch begins */
        
        if(scene!.paused && self.childNodeWithName("DragLabel") != nil) {
            self.childNodeWithName("DragLabel")!.removeFromParent()
            self.childNodeWithName("Enemy")?.removeFromParent()
            scoreLabel.text = "0"
            gameStarted = true
            scene!.paused = false
        }
        
        for touch in (touches) {
            let location = touch.locationInNode(self)
        
            currentPlayer.startDrag(location)
            
            if let name = self.nodeAtPoint(location).name{
                switch name {
                case "PauseButton":
                    if(!scene!.paused) {
                        scene!.paused = true
                        applyPauseFilter()
                    }
                case "ResumeButton":
                    if(scene!.paused) {
                        scene!.paused = false
                        removePauseFilter()
                    }
                case "ExitButton":
                    if(scene!.paused) {
                        self.removeAllActions()
                        let menuScene = MenuScene(size: self.scene!.size)
                        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                        self.scene!.view?.presentScene(menuScene, transition: transition)
                    }
                case "RestartButton":
                    if(scene!.paused) {
                        self.removeAllActions()
                        let playScene = PlayScene(size: self.scene!.size)
                        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                        self.scene!.view?.presentScene(playScene, transition: transition)
                    }
                default:
                    break
                }
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            if (!scene!.paused){
                currentPlayer!.updatePositionForDragMovement(touch.locationInNode(self))
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
            
        case ColliderObject.enemyCollider.rawValue | ColliderObject.playerCollider.rawValue:
            contact.bodyB.node!.removeActionForKey("moveEnemy")
            contact.bodyB.node!.runAction(SKAction.fadeOutWithDuration(0.1), completion: {contact.bodyB.node!.removeFromParent()})
            gameOver()
        case ColliderObject.targetCollider.rawValue | ColliderObject.playerCollider.rawValue:
            if(updatesCalled > updateBuffer) {
                scoreLabel.addScore(1) //only adds score if collision is called more than 1 frame after previous collision
            }else {
                print("Prevented score glitch") //attempted to add score again immediately after collision
            }
            contact.bodyB.node!.removeFromParent()
            newTarget = true
            updatesCalled = 0 //resets for next check
        case ColliderObject.playerCollider.rawValue | ColliderObject.coinCollider.rawValue:
            if(updatesCalled > updateBuffer) {
                NSUserDefaults().setInteger(NSUserDefaults().integerForKey("coins") + 1, forKey: "coins")
                print(NSUserDefaults().integerForKey("coins"))
            }
            
            if(contact.bodyB.node!.name == "Coin") {
                contact.bodyB.node!.runAction(SKAction.fadeOutWithDuration(0.1), completion: {contact.bodyB.node!.removeFromParent()})
            }else {
                contact.bodyA.node!.runAction(SKAction.fadeOutWithDuration(0.1), completion: {contact.bodyA.node!.removeFromParent()})
            }
            
            updatesCalled = 0
        default:
            print("Default collision")
        }
    }
    
    func addEnemy(){
        enemy = Enemy(side: SpawnSide.Right)
        let enemySpeed = (Double(arc4random_uniform(UInt32(3))) + 3.0)
        
        if (arc4random_uniform(2) == 1){
            enemy.position = CGPoint(x: self.frame.width + enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2)
            moveEnemyAction = SKAction.moveTo(CGPoint(x: -enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2), duration: enemySpeed)
        }
        else{
            enemy.position = CGPoint(x: -enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2)
            moveEnemyAction = SKAction.moveTo(CGPoint(x: self.frame.width + enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2), duration: enemySpeed)
        }
        
        enemy.runAction(moveEnemyAction!, withKey: "moveEnemy")
        self.addChild(enemy)
    }
    
    func createNewTarget() {
        target = Target()
        target.moveToRandomPosition(self.frame)
        
        self.addChild(target)
    }
    
    func createCoins() {
        let newCoinTime = Int.random(5...10)
        self.runAction(SKAction.waitForDuration(NSTimeInterval(newCoinTime)), completion: {
            self.createCoins()
        })
        
        let coin = Coin()
        coin.moveToRandomPosition(self.frame)
        
        self.addChild(coin)
        
        coin.runAction(SKAction.fadeInWithDuration(0.1))
        coin.destroyCoin()
    }
    
    func applyPauseFilter() {
        backgroundFilterNode = SKSpriteNode(color: UIColor.whiteColor(), size: self.view!.frame.size)
        backgroundFilterNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundFilterNode.zPosition = 1
        backgroundFilterNode.alpha = 0.75
        
        pauseButton.zPosition = 0
        
        self.addChild(backgroundFilterNode)
        self.addChild(resumeButton!)
        self.addChild(exitButton!)
        self.addChild(restartButton!)
    }
    
    func removePauseFilter() {
        pauseButton.zPosition = 2

        backgroundFilterNode.removeFromParent()
        resumeButton.removeFromParent()
        exitButton.removeFromParent()
        restartButton.removeFromParent()
    }
    
    func gameOver() {
        self.removeAllActions()
        let gameOverScene = GameOverScene(score: Int(scoreLabel.text!)!,size: self.scene!.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
    }
    

    func pauseSceneOnHomePress() {
        scene!.paused = true
        if((scene!.childNodeWithName("ResumeButton") == nil) && gameStarted!) {
            applyPauseFilter()
        }
    }
    
    func pauseSceneOnActive(notification: NSNotification) {
        let pauseTimer: SKAction = SKAction.repeatAction(SKAction.sequence([SKAction.waitForDuration(0),SKAction.performSelector(Selector("pauseSceneOnHomePress"), onTarget: self)]), count: 1)
        runAction(pauseTimer)
    }
}













