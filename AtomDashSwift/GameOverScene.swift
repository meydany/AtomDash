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
        
        self.addChild(gameOverLabel!)
    }
}