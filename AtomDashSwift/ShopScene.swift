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
    
    static var pink = UIColor(red: 1, green: 0.61, blue: 0.93, alpha: 1)
    static var orange = UIColor(red: 1, green: 0.74, blue: 0, alpha: 1)
    static var lightBlue = UIColor(red: 0, green: 0.82, blue: 0.92, alpha: 1)
    static var neonGreen = UIColor(red: 0, green: 0.92, blue: 0.10, alpha: 1)
    static var neonYellow = UIColor(red: 0.92, green: 0.92, blue: 0, alpha: 1)
    static var black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static var darkPink = UIColor(red: 1, green: 0, blue: 0.7, alpha: 1)
    static var darkPurple = UIColor(red: 0.58, green: 0, blue: 1, alpha: 1)
    static var brightRed = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    static var greenishBlue = UIColor(red: 0, green: 0.8, blue: 0.65, alpha: 1)
    
    let coloredPlayers: [Player] = [Player(color: UIColor.gameBlueColor(), name: "GameBluePlayer", playerCost: 100),
                                    Player(color: greenishBlue, name: "GreenishBluePlayer", playerCost: 100),
                                    Player(color: UIColor.gamePurpleColor(), name: "GamePurplePlayer", playerCost: 100),
                                    Player(color: pink, name: "PinkPlayer", playerCost: 100),
                                    Player(color: orange, name: "OrangePlayer", playerCost: 100),
                                    Player(color: darkPink, name: "DarkPinkPlayer", playerCost: 100),
                                    Player(color: darkPurple, name: "DarkPurplePlayer", playerCost: 100),
                                    Player(color: brightRed, name: "BrightRedPlayer", playerCost: 100),
                                    Player(color: UIColor.gameGoldColor(), name: "GameGoldPlayer", playerCost: 200),
                                    Player(color: lightBlue, name: "LighBluePlayer", playerCost: 1000),
                                    Player(color: neonGreen, name: "NeonGreenPlayer", playerCost: 200),
                                    Player(color: black, name: "BlackPlayer", playerCost: 500)]
    //put more players here
    
    func getCurrentPlayer () -> SKNode {
        return getPlayerNodeWithName(NSUserDefaults().objectForKey("player") as! String)
    }
    
    func getPlayerNodeWithName(playerName: String) -> Player{
        for player in coloredPlayers {
            if(player.name! == playerName) {
                return player
            }
        }
        return defaultPlayer
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
    
    var scrollView: UIScrollView!
    var previousOffset: CGFloat!
    var currentOffset: CGFloat!
    
    var menuButton: ButtonTemplate!
    var buyButton: ButtonTemplate!
    var videoButton: ButtonTemplate!
    
    var buyable: Bool!
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        NSUserDefaults().setBool(true, forKey: "NotFirstTime")
        
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
        
        buyButton = ButtonTemplate(name: "BuyButton", labelName: "BUY", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (4*self.frame.height)/10), color:  UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1))
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
        
        buyable = false
        
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
                    case "BuyButton":
                        var selectedItem: ShopItemTemplate!
                        for item in shopItems {
                            if(item.tapped == true) {
                                selectedItem = item
                            }
                        }
                        if(selectedItem != nil && selectedItem.owned == false && buyable!) {
                            selectedItem.buyItem()
                            
                            let currentCoins = NSUserDefaults().integerForKey("coins")
                            coinTextNode.text = String(NSUserDefaults().integerForKey("coins"))
                            
                            let buffer = (self.frame.width/150) * Screen.screenWidthRatio
                            let centerFactor = (coinTextNode.frame.width - coinNode.frame.width)/2
                            coinTextNode.position = CGPoint(x: ((self.frame.midX - (coinTextNode.frame.width/2)) + centerFactor) - buffer, y: (7.75*self.frame.height)/10 - (coinTextNode.frame.height/2))
                            coinNode!.position = CGPoint(x: (self.frame.midX + (coinNode.frame.width/2)) + centerFactor + buffer, y: (7.75*self.frame.height)/10)
                            
                            buyButton.fillColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1)
                        }else if(selectedItem == nil) {
                            buyButton.fillColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1)
                        }
                    default:
                        //do nothing

                        break
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
                    item.colorNode.runAction(SKAction.scaleTo(1.2, duration: 0.5))
                    item.tapped = true
                    
                    if(item.playerCost > NSUserDefaults().integerForKey("coins") || item.owned == true) {
                        buyButton.fillColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1)
                        buyable = false //unable to buy
                    }else {
                        buyButton.fillColor = UIColor.gameGreenColor()
                        buyable = true
                    }
                    
                    if(item.owned! && !item.selected!) {
                        item.selectItem()
                    }
                }else {
                    item.colorNode.runAction(SKAction.scaleTo(1.0, duration: 0.5))
                    item.tapped = false
                    
                    if(item.owned! && item.selected!) {
                        item.unselectItem()
                    }
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
