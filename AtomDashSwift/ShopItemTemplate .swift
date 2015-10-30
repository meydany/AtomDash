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
    
    var cost: Int!

    //Initializer for different image player
    init(name: String, playerImage: String, cost: Int, size: CGSize, index: Int, sceneFrame: CGRect) {
        super.init()
        let rect = CGRect(origin: CGPointZero, size: size)
        self.path = CGPathCreateWithRoundedRect(rect, CGFloat(8 * Screen.screenWidthRatio), CGFloat(8 * Screen.screenWidthRatio), nil)
        
        let initialHeight = (6.5*sceneFrame.maxY)/10
        
        var itemPosition = CGPoint(x: sceneFrame.midX, y: (initialHeight - ((CGFloat(index)) * (sceneFrame.width/4))))
        itemPosition.y -= ((self.frame.height/10) * CGFloat(index))

        self.name = name
        self.lineWidth = 1 * Screen.screenWidthRatio
        self.strokeColor = UIColor.gameGoldColor()
        self.position.x = itemPosition.x - self.frame.width/2
        self.position.y = itemPosition.y - self.frame.height/2
        self.zPosition = 1
        self.fillColor = UIColor.whiteColor()
        self.alpha = 1

    }
    
    //Initializer for different colored player
    init(name: String, playerColor: UIColor, cost: Int, size: CGSize, index: Int, sceneFrame: CGRect) {
        super.init()
        let rect = CGRect(origin: CGPointZero, size: size)
        self.path = CGPathCreateWithRoundedRect(rect, CGFloat(8 * Screen.screenWidthRatio), CGFloat(8 * Screen.screenWidthRatio), nil)
        
        let initialHeight = (6.5*sceneFrame.maxY)/10
        
        var itemPosition = CGPoint(x: sceneFrame.midX, y: (initialHeight - ((CGFloat(index)) * (sceneFrame.width/4))))
        itemPosition.y -= ((self.frame.height/10) * CGFloat(index))
        
        self.name = name
        self.lineWidth = 1 * Screen.screenWidthRatio
        self.strokeColor = UIColor.gameGoldColor()
        self.position.x = itemPosition.x - self.frame.width/2
        self.position.y = itemPosition.y - self.frame.height/2
        self.zPosition = 1
        self.fillColor = UIColor.whiteColor()
        self.alpha = 1
        
        let colorNode = Player()
        colorNode.setColor(playerColor)
        colorNode.position = CGPoint(x: self.frame.width/4, y: self.frame.height/2 - self.frame.height/40)
        
        //colorNode.position.x -= self.frame.width/2
        //colorNode.position.y = (colorNode.position.y/6.5) - colorNode.frame.height/2
        self.addChild(colorNode)

        //colorNode.position = CGPoint(x: colorNode.frame.width, y: self.frame.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

