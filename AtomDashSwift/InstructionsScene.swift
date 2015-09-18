//
//  InstructionsScene.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/17/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class InstructionsScene: SKScene {
    
    var playerNode: Player?
    var enemyNode: Enemy?
    var targetNode: Target?
    
    var lineOnePartOne: SKLabelNode?
    var lineOnePartTwo: SKLabelNode?
    
    var lineTwoPartOne: SKLabelNode?
    var lineTwoPartTwo: SKLabelNode?
    
    var lineThreePartOne: SKLabelNode?
    var lineThreePartTwo: SKLabelNode?
    
    var menuButton: SKShapeNode?
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        playerNode = Player()
        playerNode!.position = CGPoint(x: self.frame.width/4, y: (4*self.frame.height)/5)
        
        enemyNode = Enemy(side: SpawnSide.Right)
        enemyNode!.position = CGPoint(x: (2*self.frame.width)/4, y: (4*self.frame.height)/5)
        
        targetNode = Target()
        targetNode!.position = CGPoint(x: (3*self.frame.width)/4, y: (4*self.frame.height)/5)
        
        lineOnePartOne = SKLabelNode(text: "You are the")
        lineOnePartOne!.position = CGPoint(x: self.frame.width/2.7, y: (3*self.frame.height)/5)
        lineOnePartOne!.fontName = "DINCondensed-Bold"
        lineOnePartOne!.fontSize = 50
        lineOnePartOne!.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        lineOnePartTwo = SKLabelNode(text: "BLUE")
        lineOnePartTwo!.position = CGPoint(x: lineOnePartOne!.position.x + (lineOnePartTwo!.frame.width*1.8), y: (3*self.frame.height)/5)
        lineOnePartTwo!.fontName = "DINCondensed-Bold"
        lineOnePartTwo!.fontSize = 50
        lineOnePartTwo!.fontColor = UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1)
        
        lineTwoPartOne = SKLabelNode(text: "Run from the")
        lineTwoPartOne!.position = CGPoint(x: self.frame.width/2.5, y: (2.5*self.frame.height)/5)
        lineTwoPartOne!.fontName = "DINCondensed-Bold"
        lineTwoPartOne!.fontSize = 50
        lineTwoPartOne!.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        lineTwoPartTwo = SKLabelNode(text: "RED")
        lineTwoPartTwo!.position = CGPoint(x: lineOnePartOne!.position.x + (lineOnePartTwo!.frame.width * 1.9), y: (2.5*self.frame.height)/5)
        lineTwoPartTwo!.fontName = "DINCondensed-Bold"
        lineTwoPartTwo!.fontSize = 50
        lineTwoPartTwo!.fontColor = UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1)
        
        lineThreePartOne = SKLabelNode(text: "Get the")
        lineThreePartOne!.position = CGPoint(x: self.frame.width/3, y: (2*self.frame.height)/5)
        lineThreePartOne!.fontName = "DINCondensed-Bold"
        lineThreePartOne!.fontSize = 50
        lineThreePartOne!.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        lineThreePartTwo = SKLabelNode(text: "GREEN")
        lineThreePartTwo!.position = CGPoint(x: lineOnePartOne!.position.x + (lineOnePartTwo!.frame.width * 1.25), y: (2*self.frame.height)/5)
        lineThreePartTwo!.fontName = "DINCondensed-Bold"
        lineThreePartTwo!.fontSize = 50
        lineThreePartTwo!.fontColor = UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1)
        
        menuButton = ButtonTemplate(name: "MenuButton",labelName: "MENU",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (self.frame.height)/5), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        
        self.addChild(playerNode!)
        self.addChild(targetNode!)
        self.addChild(enemyNode!)
        
        self.addChild(lineOnePartOne!)
        self.addChild(lineOnePartTwo!)
        
        self.addChild(lineTwoPartOne!)
        self.addChild(lineTwoPartTwo!)
        
        self.addChild(lineThreePartOne!)
        self.addChild(lineThreePartTwo!)
        
        self.addChild(menuButton!)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if(self.nodeAtPoint(location).name == "MenuButton") {
                var menuScene = MenuScene(size: self.scene!.size)
                self.scene!.view?.presentScene(menuScene)
            }
        }
    }
    
}
