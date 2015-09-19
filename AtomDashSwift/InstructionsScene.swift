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

        lineOnePartOne = makeLabel("You are the", position: CGPoint(x: self.frame.width/2.7, y: (3*self.frame.height)/5), color: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        lineOnePartTwo = makeLabel("BLUE", position: CGPoint(x: self.frame.midX * 1.5, y: (3*self.frame.height)/5), color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        
        lineTwoPartOne = makeLabel("Run from the", position: CGPoint(x: self.frame.width/2.5, y: (2.5*self.frame.height)/5), color: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        lineTwoPartTwo = makeLabel("RED", position: CGPoint(x: lineOnePartOne!.position.x + (lineOnePartTwo!.frame.width * 1.9), y: (2.5*self.frame.height)/5), color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        
        lineThreePartOne = makeLabel("Get the", position: CGPoint(x: self.frame.width/3, y: (2*self.frame.height)/5), color: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        lineThreePartTwo = makeLabel("GREEN", position: CGPoint(x: lineOnePartOne!.position.x + (lineOnePartTwo!.frame.width * 1.25), y: (2*self.frame.height)/5), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))

        
        menuButton = ButtonTemplate(name: "MenuButton",labelName: "GOT IT",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (self.frame.height)/5), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches as Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if(self.nodeAtPoint(location).name == "MenuButton") {
                let menuScene = MenuScene(size: self.scene!.size)
                self.scene!.view?.presentScene(menuScene)
            }
        }
    }
    func makeLabel(text: String, position: CGPoint, color: UIColor) -> SKLabelNode{
        let newLabel = SKLabelNode(text: text)
        newLabel.position = position
        newLabel.fontName = "DINCondensed-Bold"
        newLabel.fontSize = 50
        newLabel.fontColor = color
        
        return newLabel
    }

}
