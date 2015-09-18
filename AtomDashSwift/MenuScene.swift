//
//  MenuScene.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var playButton: ButtonTemplate!
    var leaderboardsButton: ButtonTemplate!
    var instrunctionsButton: ButtonTemplate!
    
    var gameName: SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        gameName = SKLabelNode(text: "ATOM DASH")
        gameName.fontName = "DINCondensed-Bold"
        gameName.fontSize = 75
        gameName.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - gameName.frame.height - ((1 * self.frame.height)/10))
        gameName.fontColor = UIColor.blackColor()
        
        playButton = ButtonTemplate(name: "PlayButton",labelName: "Play",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        leaderboardsButton = ButtonTemplate(name: "LeaderboardsButton",labelName: "Leaderboards",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        
        
        self.addChild(leaderboardsButton)
        self.addChild(playButton)
        self.addChild(gameName)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}