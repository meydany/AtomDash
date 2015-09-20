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
    var instructionsButton: ButtonTemplate!
    var multiplayerButton: ButtonTemplate!
    
    var playerNode: Player!
    var enemyNode: Enemy!
    var targetNode: Target!
    
    var gameName: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        gameName = SKLabelNode(text: "ATOM DASH")
        gameName.fontName = "DINCondensed-Bold"
        gameName.fontSize = 75
        gameName.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - gameName.frame.height - ((1 * self.frame.height)/10))
        gameName.fontColor = UIColor.blackColor()
        
        playerNode = Player()
        playerNode!.position = CGPoint(x: self.frame.width/4, y: (3.5*self.frame.height)/5)
        
        enemyNode = Enemy(side: SpawnSide.Right)
        enemyNode!.position = CGPoint(x: (2*self.frame.width)/4, y: (3.5*self.frame.height)/5)
        
        targetNode = Target()
        targetNode!.position = CGPoint(x: (3*self.frame.width)/4, y: (3.5*self.frame.height)/5)
        
        playButton = ButtonTemplate(name: "PlayButton",labelName: "PLAY",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        leaderboardsButton = ButtonTemplate(name: "LeaderboardsButton",labelName: "LEADERBOARDS",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        instructionsButton = ButtonTemplate(name: "InstructionsButton",labelName: "INSTRUCTIONS",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (3*self.frame.height)/10), color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        multiplayerButton = ButtonTemplate(name: "MultiplayerButton",labelName: "MULTIPLAYER",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (2*self.frame.height)/10), color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        
        /*
        self.addChild(playerNode!)
        self.addChild(targetNode!)
        self.addChild(enemyNode!)
        */
        
        self.addChild(multiplayerButton)
        self.addChild(leaderboardsButton)
        self.addChild(instructionsButton)
        self.addChild(playButton)
        
        self.addChild(gameName)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches as Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if let name = self.nodeAtPoint(location).name{
                switch name {
                case "PlayButton":
                    if(NSUserDefaults().boolForKey("instructionsScene")) {
                        let playScene = PlayScene(size: self.scene!.size)
                        self.scene!.view?.presentScene(playScene)
                    }
                    else {
                        NSUserDefaults().setBool(true, forKey: "instructionsScene")
                        let instructionsScene = InstructionsScene(size: self.scene!.size)
                        self.scene!.view?.presentScene(instructionsScene)
                    }
                case "LeaderboardsButton":
                    print("Make this scene!", terminator: "")
                    //Make leaderbaords menu
                case "InstructionsButton":
                    let instructionsScene = InstructionsScene(size: self.scene!.size)
                    self.scene!.view?.presentScene(instructionsScene)
                case "MultiplayerButton":
                    let chooseConnectionType = ChooseMultiplayerConnectionType(size: self.scene!.size)
                    self.scene!.view?.presentScene(chooseConnectionType)
                default:
                    break
                }
            }
        }
    }
    
}