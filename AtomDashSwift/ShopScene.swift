//
//  ShopScene.swift
//  AtomDash
//
//  Created by Yoli Meydan on 10/29/15.
//  Copyright © 2015 SoyMobile. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class ShopScene: SKScene, UIScrollViewDelegate{
    
    var shopLabel: SKLabelNode!
    
    var coinNode: Coin!
    var coinTextNode: SKLabelNode!
    
    var shopItems: [ShopItemTemplate]!
    
    var scrollView: UIScrollView!
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
        shopLabel = SKLabelNode(text: "SHOP")
        shopLabel.fontName = "DINCondensed-Bold"
        shopLabel.fontSize = 75 * Screen.screenWidthRatio
        shopLabel.position = CGPoint(x: self.frame.midX, y: (self.frame.maxY - shopLabel.frame.height - ((1 * self.frame.height)/10)))
        shopLabel.fontColor = UIColor.darkGrayColor()
        
        coinNode = Coin()
        coinNode.alpha = 1
        coinNode.zPosition = 1
        
        coinTextNode = SKLabelNode()
        coinTextNode.text = String(NSUserDefaults().integerForKey("coins"))
        coinTextNode.fontName = "Helvetica-Light"
        coinTextNode.fontSize = 30 * Screen.screenWidthRatio
        coinTextNode.fontColor = UIColor.darkGrayColor()
        coinTextNode.zPosition = 1
        
        let buffer = (self.frame.width/150) * Screen.screenWidthRatio
        let centerFactor = (coinTextNode.frame.width - coinNode.frame.width)/2
        coinTextNode.position = CGPoint(x: ((self.frame.midX - (coinTextNode.frame.width/2)) + centerFactor) - buffer, y: (7.75*self.frame.height)/10 - (coinTextNode.frame.height/2))
        coinNode!.position = CGPoint(x: (self.frame.midX + (coinNode.frame.width/2)) + centerFactor + buffer, y: (7.75*self.frame.height)/10)
        
        let itemSize = CGSize(width: self.frame.width/1.5, height: self.frame.width/4)

        shopItems = []
        shopItems.append(ShopItemTemplate(name: "bluePlayer", playerColor: UIColor.gameBlueColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "greenPlayer", playerColor: UIColor.gameGreenColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.gameRedColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "goldPlayer", playerColor: UIColor.gameGoldColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.redColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))

        let initialHeight = (2.6*self.frame.maxY)/10
        let topItem = shopItems[0]
        let bottomItem = shopItems[shopItems.count-1]
        let scrollViewHeight = (topItem.position.y + topItem.frame.height/2) - (bottomItem.position.y - bottomItem.frame.height/2)
        print(scrollViewHeight)
        print(shopItems[0].frame.height * CGFloat(shopItems.count))

        scrollView = UIScrollView(frame: CGRectMake(0, initialHeight, view.frame.width, 4.5*self.frame.height/7))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        scrollView.indicatorStyle = UIScrollViewIndicatorStyle.Black
        scrollView.contentSize = CGSize(width: itemSize.width, height: scrollViewHeight)
        scrollView.alpha = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.enabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        addShopItems()
        self.addChild(shopLabel)
        self.addChild(coinTextNode)
        self.addChild(coinNode)
        
        self.view!.addSubview(scrollView)
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch?
        let positionInScene = touch.locationInNode(self)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            print("hello")
            var location: CGPoint = sender.locationInView(self.view)
            location.y = self.frame.height - location.y
            print(location)
            for item in shopItems {
                if(item.containsPoint(location)) {
                    print(item.name)
                }
            }
        }
    }
   
    
    func addShopItems() {
        for item in shopItems {
            self.addChild(item)
        }
    }
}
