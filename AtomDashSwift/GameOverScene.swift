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
    
    var userDefaults: NSUserDefaults!
    
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    var gameScore: Int!
    var highScore: Int!
    
    var restartButton: SKNode!
    var mainMenuButton: SKNode!
    
    var playerNode: Player!
    var enemyNode: Enemy!
    var targetNode: Target!
    
    init(score: Int, size: CGSize) {
        super.init(size: size)
            
        gameScore = score
        highScore = getHighScore(score)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: self.frame.midX, y: ((8*self.frame.height)/10))
        scoreLabel.text = "Score: \(gameScore!)"
        scoreLabel.fontName = "HelveticaNeue-Thin"
        scoreLabel.fontSize = 75 * PlayScene().getScreenWidthRatio()
        scoreLabel.fontColor = UIColor.blackColor()
        
        highScoreLabel = SKLabelNode()
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: (7*self.frame.height)/10)
        highScoreLabel.text = "High Score: \(highScore!)"
        highScoreLabel.fontName = "HelveticaNeue-Thin"
        highScoreLabel.fontSize = 45 * PlayScene().getScreenWidthRatio()
        highScoreLabel.fontColor = UIColor.darkGrayColor()
        
        mainMenuButton = ButtonTemplate(name: "MainMenuButton", labelName: "MENU", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor.gameBlueColor())
        
        restartButton = ButtonTemplate(name: "RestartButton", labelName: "RESTART", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor.gameGreenColor())
        
        self.addChild(mainMenuButton)
        self.addChild(restartButton)
        
        self.addChild(scoreLabel)
        self.addChild(highScoreLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch?
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name{
            
            switch name{
            case "RestartButton":
                let playScene = PlayScene(size: self.scene!.size)
                let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                self.scene!.view?.presentScene(playScene, transition: transition)
            case "MainMenuButton":
                let menuScene = MenuScene(size: self.scene!.size)
                let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                self.scene!.view?.presentScene(menuScene, transition: transition)
            default:
                break
            }
            
        }
    }
    
    func getHighScore(score: Int) -> Int {
        var highScore = NSUserDefaults().integerForKey("highScore")
        
        if(score > highScore) {
            NSUserDefaults().setInteger(score, forKey: "highScore")
            GCHelper.sharedInstance.reportLeaderboardIdentifier("AtomDashLeaderboardID", score: score)
            highScore = score
        }
        
        return highScore
    }
}