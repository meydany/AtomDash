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
    
    var currentViewController: UIViewController!
    static var presentAdMob = false //Global variable avaibible to all instances of GameOverScene
    var stopPresentingAds: Bool!
    
    static var adMobInterstitial: GADInterstitial = GADInterstitial(adUnitID:  "ca-app-pub-6617045441182490/5528519368")
    static var timesPlayed: Int = 0
    
    init(score: Int, size: CGSize) {
        super.init(size: size)
        
        gameScore = score
        highScore = getHighScore(score)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        loadInterstitialAd()
        stopPresentingAds = false
        
        GameOverScene.timesPlayed++
        
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
        gameOverScoreText.position = CGPoint(x: self.frame.midX, y: (6.3*self.frame.height)/10)
        gameOverScoreText.fontName = "Helvetica-Light"
        gameOverScoreText.fontSize = 50 * Screen.screenWidthRatio
        gameOverScoreText.fontColor = UIColor.darkGrayColor()
        gameOverScoreText.zPosition = 1
        
        gameOverHighscoreText = SKLabelNode()
        gameOverHighscoreText.text = "High Score: \(highScore)"
        gameOverHighscoreText.position = CGPoint(x: self.frame.midX, y: (5.2*self.frame.height)/10)
        gameOverHighscoreText.fontName = "Helvetica-Light"
        gameOverHighscoreText.fontSize = 30 * Screen.screenWidthRatio
        gameOverHighscoreText.fontColor = UIColor.darkGrayColor()
        gameOverHighscoreText.zPosition = 1
        
        self.addChild(gameOverNode)
        self.addChild(gameOverMenuButton)
        self.addChild(gameOverRestartButton)
        self.addChild(gameOverScoreNode)
        self.addChild(gameOverScoreText)
        self.addChild(gameOverHighscoreText)
    }
    
    func loadInterstitialAd() {
        currentViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController!)!
        currentViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic
        UIViewController.prepareInterstitialAds()
    }
    
    func loadAdMobInterstitialAd() -> GADInterstitial{
        let tempAd = GADInterstitial(adUnitID:  "ca-app-pub-6617045441182490/5528519368")
        
        let request: GADRequest = GADRequest()
        request.testDevices = ["1d37a5bc162bfd28997fa7f4a7c9568c", "2e870b280621a7bf297cad79e82087b4"]
        
        tempAd.loadRequest(request)
        return tempAd
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(currentViewController.shouldPresentInterstitialAd && currentViewController.requestInterstitialAdPresentation()) {
            stopPresentingAds = true
            GameOverScene.presentAdMob = true
            GameOverScene.adMobInterstitial = loadAdMobInterstitialAd()
            print("Presented iAd")
        }else if(GameOverScene.presentAdMob && !stopPresentingAds && GameOverScene.adMobInterstitial.isReady && (GameOverScene.timesPlayed % 2 == 0)) {
            GameOverScene.adMobInterstitial.presentFromRootViewController(currentViewController)
            GameOverScene.timesPlayed = 0
            GameOverScene.adMobInterstitial = loadAdMobInterstitialAd()
            stopPresentingAds = true
            print("Presented AdMob")
        }else if(GameOverScene.timesPlayed > 2) { //Just in case iAd never loads
            GameOverScene.presentAdMob = true
            GameOverScene.adMobInterstitial = loadAdMobInterstitialAd()
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