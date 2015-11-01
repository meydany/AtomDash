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
    let defaultPlayer = Player()

    let coloredPlayers: [Player] = [Player(color: UIColor.gameBlueColor(), name: "GameBluePlayer", playerCost: 100),
                                    Player(color: UIColor.gameRedColor(), name: "GameRedPlayer", playerCost: 100),
                                    Player(color: UIColor.gameGreenColor(), name: "GameGreenPlayer", playerCost: 100),
                                    Player(color: UIColor.gamePurpleColor(), name: "GamePurplePlayer", playerCost: 100),
                                    Player(color: UIColor.gameGoldColor(), name: "GameGoldPlayer", playerCost: 100),
                                    Player(color: UIColor.blueColor(), name: "BluePlayer", playerCost: 100),
                                    Player(color: UIColor.blueColor(), name: "BluePlayer", playerCost: 100),
                                    Player(color: UIColor.blueColor(), name: "BluePlayer", playerCost: 100),
                                    Player(color: UIColor.blueColor(), name: "BluePlayer", playerCost: 100),
                                    Player(color: UIColor.blueColor(), name: "BluePlayer", playerCost: 100),
                                    Player(color: UIColor.blueColor(), name: "BluePlayer", playerCost: 100),
                                    Player(color: UIColor.blueColor(), name: "BluePlayer", playerCost: 100)]

    //put more players here
    
    func getCurrentPlayer () -> SKNode {
        switch NSUserDefaults().objectForKey("player") as! String {
        case "GameBluePlayer":
            return coloredPlayers[0]
        default:
            return coloredPlayers[0]
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
    
    var menuButton: ButtonTemplate!
    var buyButton: ButtonTemplate!
    var videoButton: ButtonTemplate!
    
    var currentScale: CGFloat!
    var previousScale: CGFloat!
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
        shopLabel = SKLabelNode(text: "THEMES")
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
        
        menuButton = ButtonTemplate(name: "MenuButton", labelName: "MENU", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (2*self.frame.height)/10), color: UIColor.gameBlueColor())
        menuButton.zPosition = ShopLayers.labelLayer
        
        buyButton = ButtonTemplate(name: "BuyButton", labelName: "BUY", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color: UIColor.gameGreenColor())
        buyButton.zPosition = ShopLayers.labelLayer
        
        videoButton = ButtonTemplate(name: "VideoButton", labelName: "EARN COINS", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (3*self.frame.height)/10), color: UIColor.gameGoldColor())
        videoButton.zPosition = ShopLayers.labelLayer

        shopItems = []
        
        addColoredPlayers()

        let leftMostItem = shopItems[0]
        let rightMostItem = shopItems[shopItems.count-1]

        let leftMostItemPos = leftMostItem.position.x
        let rightMostItemPos = rightMostItem.position.x
        let scrollViewContentWidth = (rightMostItemPos - leftMostItemPos) + 1.15*leftMostItem.frame.width
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0.3*self.frame.height, width: self.frame.width, height: self.frame.height/5))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = false
        scrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        scrollView.contentSize = CGSize(width: scrollViewContentWidth, height: scrollView.frame.height)
        scrollView.alpha = 1
        
        currentOffset = scrollView.contentOffset.x
        previousOffset = currentOffset
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.enabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        currentScale = 1
        previousScale = currentScale
        
        self.view!.addSubview(scrollView)
        self.addChild(shopLabel)
        self.addChild(coinTextNode)
        self.addChild(coinNode)
        self.addChild(menuButton)
        self.addChild(buyButton)
        self.addChild(videoButton)
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
            currentOffset = scrollView.contentOffset.x
            item.position.x -= (currentOffset - previousOffset)
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
    
    func addColoredPlayers() {
        for player in Players().coloredPlayers {
            shopItems.append(ShopItemTemplate(name: player.name!, player: player, cost: player.cost!, size: CGSize(width: 4*Players().defaultPlayer.frame.width/3, height: 4*Players().defaultPlayer.frame.height/3), index: shopItems.count, sceneFrame: self.frame))
            self.addChild(shopItems[shopItems.count-1])
        }
    }
    
    override func willMoveFromView(view: SKView) {
        scrollView.removeFromSuperview()
    }
}
