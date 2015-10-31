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


struct Players {
    let defaultPlayer = Player(color: UIColor.gameBlueColor())

    //put more players here
    
    func getCurrentPlayer () -> SKNode {
        switch NSUserDefaults().objectForKey("player") as! String {
        case "Default":
            return defaultPlayer
        default:
            return defaultPlayer
        }
    }
}

public struct ShopLayers {
    static var labelLayer = CGFloat(4)
    static var whiteLayer = CGFloat(3)
    static var viewLayer = CGFloat(2)
    static var buttonLayer = CGFloat(1)
}
class ShopScene: SKScene, UIScrollViewDelegate{
    
    var shopLabel: SKLabelNode!
    
    var coinNode: Coin!
    var coinTextNode: SKLabelNode!
    
    var shopItems: [ShopItemTemplate]!
    var nodesToScroll: SKNode!
    
    var scrollView: UIScrollView!
    var previousOffset: CGFloat!
    var currentOffset: CGFloat!
    
    var changeOffset: Bool!
    
    var menuButton: ButtonTemplate!
    
    var topBackgroundFilterNode: SKSpriteNode!
    var bottomBackgroundFilterNode: SKSpriteNode!

    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
        shopLabel = SKLabelNode(text: "SHOP")
        shopLabel.fontName = "DINCondensed-Bold"
        shopLabel.fontSize = 75 * Screen.screenWidthRatio
        shopLabel.position = CGPoint(x: self.frame.midX, y: (self.frame.maxY - shopLabel.frame.height - ((1 * self.frame.height)/10)))
        shopLabel.fontColor = UIColor.darkGrayColor()
        shopLabel.zPosition = ShopLayers.labelLayer
        
        coinNode = Coin()
        coinNode.alpha = 1
        coinNode.zPosition = ShopLayers.labelLayer
        
        coinTextNode = SKLabelNode()
        coinTextNode.text = String(NSUserDefaults().integerForKey("coins"))
        coinTextNode.fontName = "Helvetica-Light"
        coinTextNode.fontSize = 30 * Screen.screenWidthRatio
        coinTextNode.fontColor = UIColor.darkGrayColor()
        coinTextNode.zPosition = ShopLayers.labelLayer
        
        let buffer = (self.frame.width/150) * Screen.screenWidthRatio
        let centerFactor = (coinTextNode.frame.width - coinNode.frame.width)/2
        coinTextNode.position = CGPoint(x: ((self.frame.midX - (coinTextNode.frame.width/2)) + centerFactor) - buffer, y: (7.75*self.frame.height)/10 - (coinTextNode.frame.height/2))
        coinNode!.position = CGPoint(x: (self.frame.midX + (coinNode.frame.width/2)) + centerFactor + buffer, y: (7.75*self.frame.height)/10)
        
        menuButton = ButtonTemplate(name: "MenuButton", labelName: "MENU", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (0.6*self.frame.height)/10), color: UIColor.gameGoldColor())
        menuButton.zPosition = ShopLayers.labelLayer

        let itemSize = CGSize(width: self.frame.width/1.5, height: self.frame.width/4)

        shopItems = []
        shopItems.append(ShopItemTemplate(name: "bluePlayer", playerColor: UIColor.gameBlueColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "greenPlayer", playerColor: UIColor.gameGreenColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.gameRedColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "goldPlayer", playerColor: UIColor.gameGoldColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.redColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.redColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.redColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.redColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))
        shopItems.append(ShopItemTemplate(name: "redPlayer", playerColor: UIColor.redColor(), cost: 100, size: itemSize, index: shopItems.count, sceneFrame: self.frame))

        let initialHeight = (2.6*self.frame.maxY)/10
        let topItem = shopItems[0]
        let bottomItem = shopItems[shopItems.count-1]
        let scrollViewHeight = (topItem.position.y + topItem.frame.height/2) - (bottomItem.position.y - bottomItem.frame.height/2)
        print(scrollViewHeight)
        print(shopItems[0].frame.height * CGFloat(shopItems.count))

        scrollView = UIScrollView(frame: CGRectMake(0, initialHeight, view.frame.width, 4.2*self.frame.height/7))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = false
        scrollView.indicatorStyle = UIScrollViewIndicatorStyle.Black
        scrollView.contentSize = CGSize(width: itemSize.width, height: scrollViewHeight)
        scrollView.alpha = 1
        
        currentOffset = scrollView.contentOffset.y
        previousOffset = currentOffset
        
        changeOffset = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.enabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        topBackgroundFilterNode = SKSpriteNode(color: UIColor.whiteColor(), size: self.view!.frame.size)
        topBackgroundFilterNode.position = CGPoint(x: self.frame.midX, y: (initialHeight - self.frame.height/40) + topBackgroundFilterNode.frame.height)
        topBackgroundFilterNode.zPosition = ShopLayers.whiteLayer
        topBackgroundFilterNode.alpha = 1
        
        bottomBackgroundFilterNode = SKSpriteNode(color: UIColor.whiteColor(), size: self.view!.frame.size)
        bottomBackgroundFilterNode.position = CGPoint(x: self.frame.midX, y: (menuButton.position.y + 2*self.frame.height/20) - bottomBackgroundFilterNode.frame.height/2)
        bottomBackgroundFilterNode.zPosition = ShopLayers.whiteLayer
        bottomBackgroundFilterNode.alpha = 1
        
        addShopItems()
        self.addChild(shopLabel)
        self.addChild(coinTextNode)
        self.addChild(coinNode)
        self.addChild(menuButton)
        self.addChild(topBackgroundFilterNode)
        self.addChild(bottomBackgroundFilterNode)
        
        self.view!.addSubview(scrollView)
    }
    
    override func update(currentTime: CFTimeInterval) {

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches as Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            self.removeAllActions()
            if let name = self.nodeAtPoint(location).name{
                switch name {
                    case "MenuButton":
                        let menuScene = MenuScene(size: self.scene!.size)
                        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                        self.scene!.view?.presentScene(menuScene, transition: transition)
                    default:
                        let menuScene = MenuScene(size: self.scene!.size)
                        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                        self.scene!.view?.presentScene(menuScene, transition: transition)
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for item in shopItems  {
            currentOffset = scrollView.contentOffset.y
            item.position.y += (currentOffset - previousOffset)
        }
        previousOffset = currentOffset
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            var location: CGPoint = sender.locationInView(self.view)
            location.y = self.frame.height - location.y
            for item in shopItems {
                if(item.containsPoint(location)) {
                    print(item.name)
                }
            }
        }
    }
    
    func addShopItems() {
        for item in shopItems {
            item.zPosition = ShopLayers.buttonLayer
            self.addChild(item)
        }
    }
    
    override func willMoveFromView(view: SKView) {
        scrollView.removeFromSuperview()
    }
}
