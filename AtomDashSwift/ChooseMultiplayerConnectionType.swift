//
//  ChooseMultiplayerConnectionType.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/20/15.
//  Copyright © 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import GameKit

class ChooseMultiplayerConnectionType: SKScene {
    
    var multiplayerLabel: SKLabelNode!
    
    var gameCenterButton: ButtonTemplate!
    var wifiBluetoothButton: ButtonTemplate!
    var instructionsButton: ButtonTemplate!
    var menuButton: ButtonTemplate!
    
    var singlePlayerNode: Player!
    var multiplayerPlayerNode: MultiplayerPlayerNode!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        multiplayerLabel = SKLabelNode(text: "MULTIPLAYER")
        multiplayerLabel.fontName = "DINCondensed-Bold"
        multiplayerLabel.fontSize = 75 * Screen.screenWidthRatio
        multiplayerLabel.position = CGPoint(x: self.frame.midX, y: (self.frame.maxY - multiplayerLabel.frame.height - ((1 * self.frame.height)/10)))
        multiplayerLabel.fontColor = UIColor.darkGrayColor()
        
        singlePlayerNode = Player()
        singlePlayerNode!.position = CGPoint(x: self.frame.width/3, y: (3.4*self.frame.height)/5)
        
        multiplayerPlayerNode = MultiplayerPlayerNode()
        multiplayerPlayerNode!.position = CGPoint(x: (2*self.frame.width)/3, y: (3.4*self.frame.height)/5)
        
        gameCenterButton = ButtonTemplate(name: "GameCenterButton", labelName: "GAME CENTER", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor.gameGreenColor())
        
        wifiBluetoothButton = ButtonTemplate(name: "WifiBluetoothButton", labelName: "WIFI/BLUETOOTH", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor.gamePurpleColor())
        
        instructionsButton = ButtonTemplate(name: "InstructionsButton", labelName: "INSTRUCTIONS", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (3*self.frame.height)/10), color: UIColor.gameRedColor())
        
        menuButton = ButtonTemplate(name: "MenuButton", labelName: "MENU", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (2*self.frame.height)/10), color: UIColor.gameBlueColor())
        
        
        self.addChild(gameCenterButton)
        self.addChild(wifiBluetoothButton)
        self.addChild(instructionsButton)
        self.addChild(menuButton)
        
        self.addChild(multiplayerLabel)
        
        self.addChild(singlePlayerNode)
        self.addChild(multiplayerPlayerNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            if let name = self.nodeAtPoint(location).name{
            self.removeAllActions()
            switch name{
                case "GameCenterButton":
                    let currentViewController: UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController!)!
                    GCHelper.sharedInstance.findMatchWithMinPlayers(2, maxPlayers: 2, viewController: currentViewController, delegate: currentViewController as! GCHelperDelegate)
                    break
                case "InstructionsButton":
                    let instructionsScene = MultiplayerInstructionsScene(size: self.scene!.size)
                    let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                    self.scene!.view?.presentScene(instructionsScene, transition: transition)
                case "MenuButton":
                    let menuScene = MenuScene(size: self.scene!.size)
                    let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                    self.scene!.view?.presentScene(menuScene, transition: transition)
                default:
                    break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}