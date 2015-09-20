//
//  ChooseMultiplayerConnectionType.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/20/15.
//  Copyright © 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit

class ChooseMultiplayerConnectionType: SKScene {
    
    var bluetoothButton: ButtonTemplate!
    var gamecenterButton: ButtonTemplate!
    var facebookButton: ButtonTemplate!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        bluetoothButton = ButtonTemplate(name: "BluetoothButton",labelName: "BLUETOOTH",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (5*self.frame.height)/10), color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        gamecenterButton = ButtonTemplate(name: "GameCenterButton",labelName: "GAMECENTER",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        facebookButton = ButtonTemplate(name: "FacebookButton",labelName: "FACEBOOK",  size: CGSize(width: self.frame.width/2.5, height: self.frame.width/8), position: CGPoint(x: self.frame.midX, y: (3*self.frame.height)/10), color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        
        self.addChild(bluetoothButton)
        self.addChild(gamecenterButton)
        self.addChild(facebookButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            if let name = self.nodeAtPoint(location).name{
            switch name{
                case "BluetoothButton":
                    let currentViewController: UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController!)!
                    currentViewController.presentViewController(SessionConnectingViewController(), animated: false, completion: nil)
                    break
                case "GameCenterButton":
                    print("GameCenter")
                    break
                case "FacebookButton":
                    print("facebook")
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