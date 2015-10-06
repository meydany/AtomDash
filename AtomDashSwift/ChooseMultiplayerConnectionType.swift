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
    
    var gameCenterButton: ButtonTemplate!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        gameCenterButton = ButtonTemplate(name: "GameCenterButton", labelName: "GAME CENTER", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (8 * self.frame.height)/10), color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        
        
        self.addChild(gameCenterButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            if let name = self.nodeAtPoint(location).name{
            switch name{
                case "GameCenterButton":
                    let currentViewController: UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController!)!
                    GCHelper.sharedInstance.findMatchWithMinPlayers(2, maxPlayers: 2, viewController: currentViewController, delegate: currentViewController as! GCHelperDelegate)
                    break
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