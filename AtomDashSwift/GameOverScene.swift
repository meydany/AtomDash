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
        
        let scalingFactor = min(self.frame.width / self.frame.width, self.frame.height / self.frame.height)/1.25

        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: self.frame.midX, y: (8*self.frame.height)/10)
        scoreLabel.text = "Score: \(gameScore!)"
        scoreLabel.fontName = "DINCondensed-Bold"
        scoreLabel.fontSize = 75 * scalingFactor
        scoreLabel.fontColor = UIColor.darkGrayColor()
        
        highScoreLabel = SKLabelNode()
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: (6.5*self.frame.height)/10)
        highScoreLabel.text = "High Score: \(highScore!)"
        highScoreLabel.fontName = "DINCondensed-Bold"
        highScoreLabel.fontSize = 65 * scalingFactor
        highScoreLabel.fontColor = UIColor.darkGrayColor()
        
        mainMenuButton = ButtonTemplate(name: "MainMenuButton", labelName: "MENU", size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        
        restartButton = ButtonTemplate(name: "RestartButton", labelName: "RESTART", size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (2.5*self.frame.height)/10), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        
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
                self.scene!.view?.presentScene(playScene)
                break
            case "MainMenuButton":
                let menuScene = MenuScene(size: self.scene!.size)
                self.scene!.view?.presentScene(menuScene)
                break
            default:
                break
            }
            
        }
    }
    
    func getHighScore(score: Int) -> Int {
        var highScore = NSUserDefaults().integerForKey("highScore")
        
        if(score > highScore) {
            NSUserDefaults().setInteger(score, forKey: "highScore")
            highScore = score
        }
        
        return highScore
    }
}