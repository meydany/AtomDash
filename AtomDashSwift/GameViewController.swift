//
//  GameViewController.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import iAd

public struct Screen {
    static var screenWidth = UIScreen.mainScreen().bounds.size.width
    static var screenWidthRatio = screenWidth/375
    
    static var screenHeight = UIScreen.mainScreen().bounds.size.height
    static var screenHeightRatio = screenHeight/667
    
    static var screenRatio = screenWidth/screenHeight
}

class GameViewController: UIViewController {
    
    var menuScene: SKScene!
    var connectButton: UIButton!
    var skView: SKView!
    var isClient: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GameViewController"
        
        // Configure the view.
        skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.multipleTouchEnabled = false
        
        menuScene = MenuScene(size: skView.bounds.size)

        /* Set the scale mode to scale to fit the window */
        menuScene!.scaleMode = .AspectFill
        
        self.skView.presentScene(self.menuScene!)
        
        //Loads ads
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic
        GameOverScene.loadAdMobInterstitialAd()
        GameOverScene.loadiAdInterstitialAd()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
//    extension SKNode {
//        class func unarchiveFromFile(file : String) -> SKNode? {
//            if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
//                var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
//                var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//                
//                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//                let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
//                archiver.finishDecoding()
//                return scene
//            } else {
//                return nil
//            }
//        }
//    }

}
