//
//  MultiplayerPlayScene.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/20/15.
//  Copyright © 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import Darwin
import GameKit

class MultiplayerPlayScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var enemy: Enemy!
    var target: Target!
    
    var scoreLabel: ScoreLabel!
    
    var pauseButton: SKNode!
    var resumeButton: ButtonTemplate!
    var exitButton: ButtonTemplate!
    var restartButton: ButtonTemplate!
    
    var newTarget: Bool!
    
    var moveEnemyAction: SKAction!
    
    var timer: NSTimer!
    
    var backgroundFilterNode: SKSpriteNode!
    
    var initialPauseWait: Bool!
    
    var isClient: Bool!
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody!.categoryBitMask = ColliderObject.wallCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
        self.physicsBody!.collisionBitMask = ColliderObject.playerCollider.rawValue
        
        isClient = (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).isClient
        
        //Player instantiation
        player = Player()
        player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        target = Target()
        if isClient == true{
            //Target instantiation
            target.moveToRandomPosition(self.frame)
            newTarget = false
            
            // Creating enemies
            runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.6),SKAction.runBlock(addEnemy)])))
        }
        else{
            //set target location that you get from Client
            
            // getting the create enemies from the Client
        }
        
        //Buffer for label's positition
        let labelBuffer: CGFloat = self.frame.width/20
        
        // Creating the ScoreLabel
        scoreLabel = ScoreLabel()
        scoreLabel.position = CGPoint(x: self.frame.midX + scoreLabel.frame.width/2, y: self.frame.maxY - labelBuffer)
        
        // Creating a pause button
        pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        pauseButton.xScale = 0.9
        pauseButton.yScale = 0.9
        pauseButton.position.x = self.frame.minX + (pauseButton!.frame.width * 0.75)
        pauseButton.position.y = self.frame.minY + (pauseButton!.frame.height * 0.75)
        pauseButton.name = "PauseButton"
        
        resumeButton = ButtonTemplate(name: "ResumeButton",labelName: "RESUME",  size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (3*self.frame.height)/5), color: UIColor.gameBlueColor())
        exitButton = ButtonTemplate(name: "ExitButton", labelName: "EXIT", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (2*self.frame.height)/5), color: UIColor.gameRedColor())
        restartButton = ButtonTemplate(name: "RestartButton", labelName: "RESTART", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor.gameGreenColor())
        
        self.addChild(pauseButton)
        self.addChild(player)
        self.addChild(target)
        self.addChild(scoreLabel)
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(isClient == true && newTarget!) {
            createNewTarget()
            newTarget = false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        /* Called when a touch begins */
        
        for touch in (touches) {
            let location = touch.locationInNode(self)
            
            player.startDrag(location)
            
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
                case "ResumeButton":
                    if(scene!.paused) {
                        scene!.paused = false
                        
                        removeFilter()
                        resumeButton.removeFromParent()
                        exitButton.removeFromParent()
                        restartButton.removeFromParent()
                    }
                case "ExitButton":
                    if(scene!.paused) {
                        let menuScene = MenuScene(size: self.scene!.size)
                        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                        self.scene!.view?.presentScene(menuScene, transition: transition)
                    }
                case "RestartButton":
                    if(scene!.paused) {
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
                player!.updatePositionForDragMovement(touch.locationInNode(self))
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
            contact.bodyB.node!.removeFromParent()
            scoreLabel.addScore(1)
            newTarget = true
            
        default:
            print("Default collision", terminator: "")
        }
    }
    
    func addEnemy(){
        enemy = Enemy(side: SpawnSide.Right)
        let enemySpeed = (Double(arc4random_uniform(UInt32(3))) + 3.0)
        let startingPosition: CGPoint!
        
        if (arc4random_uniform(2) == 1){
            startingPosition = CGPoint(x: self.frame.width + enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2)
            moveEnemyAction = SKAction.moveTo(CGPoint(x: -enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2), duration: enemySpeed)
        }
        else{
            startingPosition = CGPoint(x: -enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2)
            moveEnemyAction = SKAction.moveTo(CGPoint(x: self.frame.width + enemy.frame.width, y: CGFloat(arc4random_uniform(UInt32((self.frame.height + 1) - enemy.frame.height))) + enemy.frame.height/2), duration: enemySpeed)
        }
        
        // Check every 1 second that enemy positions are synced
        enemy.position = startingPosition
        
        enemy.runAction(moveEnemyAction!, withKey: "moveEnemy")
        self.addChild(enemy)
    }
    
    // Gets the instantiated enemy from the Client
    func getEnemy(startingPosition: CGPoint, enemySpeed: Double, moveEnemyAction: SKAction){
        enemy = Enemy(side: SpawnSide.Right)
        enemy.position = startingPosition
        enemy.runAction(moveEnemyAction)
        self.addChild(enemy)
    }
    
    func createNewTarget() {
        target = Target()
        target.moveToRandomPosition(self.frame)
        
        self.addChild(target)
    }
    
    // Gets target Position from Client
    func getTarget(position: CGPoint){
        target = Target()
        target.position = position
        
        self.addChild(target)
    }
    
    // DidRecieveData function
    func didRecieveData(match: GKMatch, didReceiveData: NSData, fromPlayer: String){
        // Recieve + set position of enemy node (every frame)
        
        // Recieve + set position of target (when it sends a message that the target is gone)
        
        // Recieve + set position of enemies (when instantiated)
        // Recieve position of Enemies every 1 second (to make sure they are on track)
        
        //var data: DataPacket = DataPacket(enemyNodePosition: <#T##CGPoint!#>, targetPosition: <#T##CGPoint!#>, multiplayerNode: <#T##CGPoint!#>, newTarget: <#T##Bool!#>, newEnemy: <#T##Bool!#>)
    
    }
    
    func applyFilter() {
        backgroundFilterNode = SKSpriteNode(color: UIColor.whiteColor(), size: self.view!.frame.size)
        backgroundFilterNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundFilterNode.zPosition = self.scene!.zPosition + 1
        backgroundFilterNode.alpha = 0.75
        
        self.addChild(backgroundFilterNode)
    }
    
    func removeFilter() {
        backgroundFilterNode.removeFromParent()
    }
    
    func gameOver() {
        let gameOverScene = GameOverScene(score: Int(scoreLabel.text!)!,size: self.scene!.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func getScreenWidthRatio() -> CGFloat {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return screenWidth/375 //iphone 6 screen width (everything will be relative to this width)
    }
    
    func getScreenHeightRatio() -> CGFloat {
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        return screenHeight/667 //iphone 6 screen height (everything will be relative to this height)
    }
    
    func getScreenRatio() -> CGFloat {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        return screenWidth/screenHeight
        //return getScreenWidthRatio()/getScreenHeightRatio()
    }
}













