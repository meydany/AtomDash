//
//  GameOverScene.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import UIKit
import GameKit
import iAd
import GoogleMobileAds

class GameOverScene: SKScene {
    
    var userDefaults: NSUserDefaults!
    
    var gameOverNode: SKLabelNode!
    var gameOverMenuButton: ButtonTemplate!
    var gameOverRestartButton: ButtonTemplate!
    var gameOverScoreNode: SKShapeNode!
    var gameOverScoreText: SKLabelNode!
    var gameOverHighscoreText: SKLabelNode!
    
    var gameScore: Int!
    var highScore: Int!
    
    var coinNode: Coin!
    var coinTextNode: SKLabelNode!
    
    //Global variables avaibible to all instances of GameOverScene
    static var currentViewController: UIViewController! = (UIApplication.sharedApplication().keyWindow?.rootViewController!)!
    static var adMobInterstitial: GADInterstitial = GADInterstitial(adUnitID:  "ca-app-pub-6617045441182490/7435571367")
    static var timesPlayed: Int = 2
   
    var presentAds: Bool!
    
    var adsEnabled: Bool!
    
    init(score: Int, size: CGSize) {
        super.init(size: size)
        
        gameScore = score
        highScore = getHighScore(score)
        
        presentAds = false
        GameOverScene.timesPlayed++
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        gameOverNode = SKLabelNode(text: "GAME OVER")
        gameOverNode.fontName = "DINCondensed-Bold"
        gameOverNode.fontSize = 75 * Screen.screenWidthRatio
        gameOverNode.position = CGPoint(x: self.frame.midX, y: (self.frame.maxY - gameOverNode.frame.height - ((1 * self.frame.height)/10)))
        gameOverNode.zPosition = 1
        gameOverNode.fontColor = UIColor.darkGrayColor()
        
        gameOverMenuButton = ButtonTemplate(name: "MenuButton", labelName: "MENU", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (2.5*self.frame.height)/10), color: UIColor.gameBlueColor())
        
        gameOverRestartButton = ButtonTemplate(name: "RestartButton", labelName: "RESTART", size: CGSize(width: self.frame.width/2, height: self.frame.width/7), position: CGPoint(x: self.frame.midX, y: (3.5*self.frame.height)/10), color: UIColor.gameGreenColor())
        
        gameOverScoreNode = SKShapeNode(rectOfSize: CGSize(width: self.frame.width/1.5, height: self.frame.width/2), cornerRadius: 10 * Screen.screenWidthRatio)
        gameOverScoreNode.position = CGPoint(x: self.frame.midX, y: (6*self.frame.height)/10)
        gameOverScoreNode.zPosition = 1
        gameOverScoreNode.fillColor = UIColor.whiteColor()
        gameOverScoreNode.strokeColor = UIColor.darkGrayColor()
        gameOverScoreNode.glowWidth = 0.1
        gameOverScoreNode.name = "GameOverScoreNode"
        
        gameOverScoreText = SKLabelNode()
        gameOverScoreText.text = "Score: \(gameScore)"
        gameOverScoreText.position = CGPoint(x: self.frame.midX, y: (6.4*self.frame.height)/10)
        gameOverScoreText.fontName = "Helvetica-Light"
        gameOverScoreText.fontSize = 50 * Screen.screenWidthRatio
        gameOverScoreText.fontColor = UIColor.darkGrayColor()
        gameOverScoreText.zPosition = 1
        
        gameOverHighscoreText = SKLabelNode()
        gameOverHighscoreText.text = "High Score: \(highScore)"
        gameOverHighscoreText.position = CGPoint(x: self.frame.midX, y: (5.6*self.frame.height)/10)
        gameOverHighscoreText.fontName = "Helvetica-Light"
        gameOverHighscoreText.fontSize = 30 * Screen.screenWidthRatio
        gameOverHighscoreText.fontColor = UIColor.darkGrayColor()
        gameOverHighscoreText.zPosition = 1
        
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
        coinTextNode.position = CGPoint(x: ((self.frame.midX - (coinTextNode.frame.width/2)) + centerFactor) - buffer, y: (5.1*self.frame.height)/10 - (coinTextNode.frame.height/2))
        coinNode!.position = CGPoint(x: (self.frame.midX + (coinNode.frame.width/2)) + centerFactor + buffer, y: (5.09*self.frame.height)/10)

        
        self.addChild(gameOverNode)
        self.addChild(gameOverMenuButton)
        self.addChild(gameOverRestartButton)
        self.addChild(gameOverScoreNode)
        self.addChild(gameOverScoreText)
        self.addChild(gameOverHighscoreText)
        self.addChild(coinNode)
        self.addChild(coinTextNode)
        
        // A variable for determining whether the user has ads
        adsEnabled = true
        
        if adsEnabled == true{
            runAction(SKAction.waitForDuration(0.05), completion: {self.presentAds = true})
        }
    }
    
    static func loadiAdInterstitialAd() {
        print("Loading iAd")
        
        UIViewController.prepareInterstitialAds()
    }
    
    static func loadAdMobInterstitialAd() -> GADInterstitial{
        print("Loading Admob")
        let tempAd = GADInterstitial(adUnitID:  "ca-app-pub-6617045441182490/7435571367")
        
        let request: GADRequest = GADRequest()
        request.testDevices = ["1d37a5bc162bfd28997fa7f4a7c9568c", "2e870b280621a7bf297cad79e82087b4", "689ae27c9872f7a8a2623f9805361309"]
        
        tempAd.loadRequest(request)
        return tempAd
    }
    
    func presentiAdInterstitialAd() {
        print("Presented iAd")
        
        presentAds = false

        GameOverScene.currentViewController.requestInterstitialAdPresentation()
        GameOverScene.timesPlayed = 0

        //Reloads ads
        GameOverScene.loadiAdInterstitialAd()
        GameOverScene.adMobInterstitial = GameOverScene.loadAdMobInterstitialAd()
    }
    
    func presentAdMobInterstitialAd() {
        print("Presented AdMob")

        presentAds = false

        GameOverScene.adMobInterstitial.presentFromRootViewController(GameOverScene.currentViewController)
        GameOverScene.timesPlayed = 0
        
        //Reloads ads
        GameOverScene.adMobInterstitial = GameOverScene.loadAdMobInterstitialAd()
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(presentAds! && (GameOverScene.timesPlayed % 4 == 0)  && GameOverScene.currentViewController.requestInterstitialAdPresentation().boolValue) {
            self.presentiAdInterstitialAd()
        }else if(presentAds! && (GameOverScene.timesPlayed % 4 == 0) && GameOverScene.adMobInterstitial.isReady) {
            self.presentAdMobInterstitialAd()
        }else if(presentAds! && (GameOverScene.timesPlayed % 4 == 0)) {
            print("No ad availible")
            GameOverScene.loadiAdInterstitialAd()
            GameOverScene.adMobInterstitial = GameOverScene.loadAdMobInterstitialAd()
            GameOverScene.timesPlayed-- //Insures ad is displayed on next death
            presentAds = false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch?
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name{
            
            switch name{
            case "RestartButton":
                let playScene = PlayScene(size: self.scene!.size)
                let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                self.scene!.view?.presentScene(playScene, transition: transition)
            case "MenuButton":
                let menuScene = MenuScene(size: self.scene!.size)
                let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
                self.scene!.view?.presentScene(menuScene, transition: transition)
            default:
                break
            }
            
        }
    }
    
    func getHighScore(score: Int) -> Int {
        var highScore = NSUserDefaults().integerForKey("highScore")
        
        if(score > highScore) {
            NSUserDefaults().setInteger(score, forKey: "highScore")
            GKNotificationBanner.showBannerWithTitle("High Score!", message: "New High Score: \(score)", completionHandler: {
                () -> Void in
                if(GKLocalPlayer.localPlayer().authenticated) {
                    GCHelper.sharedInstance.reportLeaderboardIdentifier("AtomDashLeaderboardID", score: score)
                }
            })
            highScore = score
        }
        
        return highScore
    }
}
