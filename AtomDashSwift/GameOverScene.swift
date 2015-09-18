//
//  GameOverScene.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import UIKit

class GameOverScene: SKScene {
    
    var userDefaults: NSUserDefaults?
    
    var scoreLabel: SKLabelNode?
    var highScoreLabel: SKLabelNode?
    
    var gameScore: Int?
    var highScore: Int?
    
    var restartButton: SKNode?
    var mainMenuButton: SKNode?
    
    var playerNode: Player?
    var enemyNode: Enemy?
    var targetNode: Target?
    
    init(score: Int, size: CGSize) {
        super.init(size: size)
        
        gameScore = score
        highScore = getHighScore(score)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        userDefaults = NSUserDefaults()
        userDefaults?.setInteger(0, forKey: "highScore")
        
        playerNode = Player()
        playerNode!.position = CGPoint(x: self.frame.width/4, y: (4*self.frame.height)/5)
        
        enemyNode = Enemy(side: SpawnSide.Right)
        enemyNode!.position = CGPoint(x: (2*self.frame.width)/4, y: (4*self.frame.height)/5)
        
        targetNode = Target()
        targetNode!.position = CGPoint(x: (3*self.frame.width)/4, y: (4*self.frame.height)/5)
        
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        scoreLabel = SKLabelNode()
        scoreLabel!.position = CGPoint(x: self.frame.midX, y: (3*self.frame.height)/5)
        scoreLabel!.text = "Score: \(gameScore!)"
        scoreLabel!.fontName = "DINCondensed-Bold"
        scoreLabel!.fontSize = 75
        scoreLabel!.fontColor = UIColor.blackColor()
        
        highScoreLabel = SKLabelNode()
        highScoreLabel!.position = CGPoint(x: self.frame.midX, y: (2.5*self.frame.height)/5)
        highScoreLabel!.text = "High Score: \(highScore!)"
        highScoreLabel!.fontName = "DINCondensed-Bold"
        highScoreLabel!.fontSize = 75
        highScoreLabel!.fontColor = UIColor.blackColor()
        
        restartButton = SKSpriteNode(imageNamed: "button")
        restartButton?.xScale = 0.25
        restartButton?.yScale = 0.25
        restartButton?.position.x = self.frame.midX/2
        restartButton?.position.y = (self.frame.midY + self.frame.minY)/2
        restartButton?.name = "RestartButton"
        restartButton?.userInteractionEnabled = false
        
        mainMenuButton = ButtonTemplate(name: "MainMenuButton", labelName: "MENU", size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        
        restartButton = ButtonTemplate(name: "RestartButton", labelName: "RESTART", size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (2.5*self.frame.height)/10), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        
        
        self.addChild(mainMenuButton!)
        self.addChild(restartButton!)
        
        self.addChild(scoreLabel!)
        self.addChild(highScoreLabel!)
        
        self.addChild(playerNode!)
        self.addChild(targetNode!)
        self.addChild(enemyNode!)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name{
            
            switch name{
            case "RestartButton":
                var playScene = PlayScene(size: self.scene!.size)
                self.scene!.view?.presentScene(playScene)
                break
            case "MainMenuButton":
                var menuScene = MenuScene(size: self.scene!.size)
                self.scene!.view?.presentScene(menuScene)
                break
            default:
                break
            }
        }
    }
    
    func getHighScore(score: Int) -> Int {
        var currentHighScore = userDefaults?.integerForKey("highScore")
        var newHighScore = currentHighScore
        
        if(score > currentHighScore) {
            userDefaults?.setInteger(score, forKey: "highScore")
            newHighScore = score
        }
        
        return newHighScore!
    }
}