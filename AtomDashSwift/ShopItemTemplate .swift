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
    
    var playerCost: Int!
    var coinNode: Coin!
    var coinTextNode: SKLabelNode!
    
    var ownedNode: SKLabelNode!
    var selectedNode: SKLabelNode!
 
    var owned: Bool!
    var tapped: Bool!
    var selected: Bool!
    
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
        
        coinNode = Coin()
        coinNode.alpha = 1
        
        coinTextNode = SKLabelNode()
        coinTextNode.text = String(cost)
        coinTextNode.fontName = "Helvetica-Light"
        coinTextNode.fontSize = 30 * Screen.screenWidthRatio
        coinTextNode.fontColor = UIColor.darkGrayColor()
        
        let buffer = (sceneFrame.width/150) * Screen.screenWidthRatio
        let centerFactor = (coinTextNode.frame.width - coinNode.frame.width)/2
        coinTextNode.position = CGPoint(x: (self.frame.width/2) - (coinTextNode.frame.width/2) + centerFactor - buffer, y: 0 - (coinTextNode.frame.height/2))
        coinNode.position = CGPoint(x: (self.frame.width/2) + (coinNode.frame.width/2) + centerFactor + buffer, y: 0)
        
        ownedNode = SKLabelNode()
        ownedNode.text = "OWNED"
        ownedNode.fontName = "Helvetica-Light"
        ownedNode.fontSize = 20 * Screen.screenWidthRatio
        ownedNode.fontColor = UIColor.darkGrayColor()
        ownedNode.position = CGPoint(x: colorNode.position.x, y: -0.5 * ownedNode.frame.height)
        
        selectedNode = SKLabelNode()
        selectedNode.text = "SELECTED"
        selectedNode.fontName = "Helvetica-Light"
        selectedNode.fontSize = 20 * Screen.screenWidthRatio
        selectedNode.fontColor = UIColor.gameGreenColor()
        selectedNode.position = CGPoint(x: colorNode.position.x, y: 0 - (2 * selectedNode.frame.height))
        
        let ownedKey = "\(colorNode!.name)Owned"
        owned = NSUserDefaults().boolForKey(ownedKey)
        
        let name: String! = colorNode!.name
        let selectedName: String! = NSUserDefaults().objectForKey("player") as! String
        selected = name == selectedName
        
        playerCost = cost
        tapped = false

        self.addChild(colorNode)
        
        if(owned! == true) {
            self.addChild(ownedNode)
        }else {
            self.addChild(coinTextNode)
            self.addChild(coinNode)
        }
        
        if(selected! == true) {
            self.addChild(selectedNode)
            self.colorNode.setScale(1.2)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buyItem() {
        owned = true

        NSUserDefaults().setInteger(NSUserDefaults().integerForKey("coins") - self.playerCost, forKey: "coins")
        coinNode.removeFromParent()
        coinTextNode.removeFromParent()
        
        NSUserDefaults().setBool(true, forKey: "\(colorNode!.name)Owned")
        
        ownedNode.alpha = 0
        self.addChild(ownedNode!)
        ownedNode.runAction(SKAction.fadeInWithDuration(0.25))
        
        selectItem()
    }
    
    func selectItem() {
        selected = true

        let name: String! = colorNode!.name
        NSUserDefaults().setObject("\(name)", forKey: "player")
        print(NSUserDefaults().stringForKey("player"))
        
        selectedNode.alpha = 0
        self.addChild(selectedNode)
        selectedNode.runAction(SKAction.fadeInWithDuration(0.25))
    }
    
    func unselectItem() {
        selected = false
        selectedNode.alpha = 1
        selectedNode.runAction(SKAction.fadeOutWithDuration(0.25), completion: {self.selectedNode.removeFromParent()})
    }
}

