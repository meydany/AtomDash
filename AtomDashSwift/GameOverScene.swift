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
    
    var gameOverLabel: SKLabelNode?
    var gameScore: String?
    
    var restartButton: SKNode?
    var mainMenuButton: SKNode?
    
    init(score: String, size: CGSize) {
        super.init(size: size)
        
        gameScore = score
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        gameOverLabel = SKLabelNode()
        gameOverLabel!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        gameOverLabel!.text = "Score: \(gameScore!)"
        gameOverLabel!.fontName =  "HelveticaNeue-light"
        gameOverLabel!.fontSize = 30
        gameOverLabel!.fontColor = UIColor.blackColor()
        
        restartButton = SKSpriteNode(imageNamed: "button")
        restartButton?.xScale = 0.25
        restartButton?.yScale = 0.25
        restartButton?.position.x = self.frame.midX/2
        restartButton?.position.y = (self.frame.midY + self.frame.minY)/2
        restartButton?.name = "RestartButton"
        restartButton?.userInteractionEnabled = false
        
        mainMenuButton = SKSpriteNode(imageNamed: "button")
        mainMenuButton?.xScale = 0.25
        mainMenuButton?.yScale = 0.25
        mainMenuButton?.position.x = self.frame.midX * 1.5
        mainMenuButton?.position.y = (self.frame.midY + self.frame.minY)/2
        mainMenuButton?.name = "MainMenuButton"
        mainMenuButton?.userInteractionEnabled = false
        
        
        self.addChild(mainMenuButton!)
        self.addChild(restartButton!)
        self.addChild(gameOverLabel!)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name{
            if name == "RestartButton"{
                
            }
            
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
}