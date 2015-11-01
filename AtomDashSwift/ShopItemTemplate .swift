//
//  ShopItemTemplate .swift
//  AtomDash
//
//  Created by Yoli Meydan on 10/29/15.
//  Copyright © 2015 SoyMobile. All rights reserved.
//

import Foundation
import SpriteKit

class ShopItemTemplate: SKShapeNode {
    
    var colorNode: SKNode!
    var owned: Bool!
    var seelcted: Bool!
    
    //Initializer for different colored player
    init(name: String, player: SKNode, cost: Int, size: CGSize, index: Int, sceneFrame: CGRect) {
        super.init()
        
        let initialPos = CGPoint(x: (sceneFrame.width/6), y: 0.63*sceneFrame.height)
        let itemPosition = CGPoint(x: initialPos.x + (CGFloat(index) * sceneFrame.width/3), y: initialPos.y)

        let rect = CGRect(origin: CGPointZero, size: size)
        self.path = CGPathCreateWithRoundedRect(rect, CGFloat(8 * Screen.screenWidthRatio), CGFloat(8 * Screen.screenWidthRatio), nil)
        self.name = name
        self.position.x = itemPosition.x - self.frame.width/2
        self.position.y = itemPosition.y - self.frame.height/2
        self.lineWidth = 0
        self.zPosition = 1
        self.fillColor = UIColor.clearColor()
        self.alpha = 1
        
        colorNode = player
        colorNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height - colorNode.frame.height/2)
    
        let coinNode = Coin()
        coinNode.alpha = 1
        
        let coinTextNode = SKLabelNode()
        coinTextNode.text = String(cost)
        coinTextNode.fontName = "Helvetica-Light"
        coinTextNode.fontSize = 30 * Screen.screenWidthRatio
        coinTextNode.fontColor = UIColor.darkGrayColor()
        
        let buffer = (sceneFrame.width/150) * Screen.screenWidthRatio
        let centerFactor = (coinTextNode.frame.width - coinNode.frame.width)/2
        coinTextNode.position = CGPoint(x: (self.frame.width/2) - (coinTextNode.frame.width/2) + centerFactor - buffer, y: 0 - (coinTextNode.frame.height/2))
        coinNode.position = CGPoint(x: (self.frame.width/2) + (coinNode.frame.width/2) + centerFactor + buffer, y: 0)
        
        let ownedNode = SKLabelNode()
        ownedNode.text = "OWNED"
        ownedNode.fontName = "Helvetica-Light"
        ownedNode.fontSize = 20 * Screen.screenWidthRatio
        ownedNode.fontColor = UIColor.darkGrayColor()
        ownedNode.position = CGPoint(x: colorNode.position.x, y: 0)
        
        let selectedNode = SKLabelNode()
        selectedNode.text = "SELECTED"
        selectedNode.fontName = "Helvetica-Light"
        selectedNode.fontSize = 20 * Screen.screenWidthRatio
        selectedNode.fontColor = UIColor.gameGreenColor()
        selectedNode.position = CGPoint(x: colorNode.position.x, y: 0 - (1.5 * selectedNode.frame.height))
        
        let ownedKey = "\(colorNode.name)Owned"
        owned = NSUserDefaults().boolForKey(ownedKey)
        
        let selected = (NSUserDefaults().objectForKey("player") as! String) == colorNode.name

        self.addChild(colorNode)
        
        if(owned! == true) {
            self.addChild(ownedNode)
        }else {
            self.addChild(coinTextNode)
            self.addChild(coinNode)
        }
        
        if(selected) {
            self.addChild(selectedNode)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustPlayerScale(scale: CGFloat) {
        colorNode.setScale(scale)
    }
}

