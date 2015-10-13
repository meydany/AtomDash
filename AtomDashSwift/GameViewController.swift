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

class GameViewController: UIViewController, GCHelperDelegate {
    
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

        //Because authentication was lagging the game, I'm using a thread to start both at the same time
        dispatch_async(dispatch_get_main_queue(), {
            self.skView.presentScene(self.menuScene!) //Thread 2
            GCHelper.sharedInstance.authenticateLocalUser() //Thread 1
        })
        
        //Loads ads
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic
        GameOverScene.loadAdMobInterstitialAd()
        GameOverScene.loadiAdInterstitialAd()
    }
    
    func match(match: GKMatch, didReceiveData: NSData, fromPlayer: String) {
        print("Recieving Data...")
        var info: Int = 0
        didReceiveData.getBytes(&info, length: sizeof(Int))
        
        print("\(info) recieved")
        
        MultiplayerPlayScene().didRecieveData(match, didReceiveData: didReceiveData, fromPlayer: fromPlayer)
    }
    
    func matchStarted() {
        let currentViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController!)?.view as! SKView
        currentViewController.presentScene(MultiplayerPlayScene())
        print("Match Started")
        // Share NSdaata
        var num: Int = 100
        let sampleData: NSData = NSData(bytes: &num, length: sizeof(Int))
        print("Sending data")
        
        do {
            try GCHelper.sharedInstance.match.sendDataToAllPlayers(sampleData, withDataMode: .Reliable)
        }
        catch{
            print("there was an error \(error)")
        }
        
        GCHelper.sharedInstance.match.chooseBestHostingPlayerWithCompletionHandler({(player) -> Void in
            if (player!.playerID == GKLocalPlayer.localPlayer().playerID){
                self.isClient = true
            }
            else{
                self.isClient = false
            }
            
            // More Efficent line, not sure if it works in swift
            // self.isClient = player!.playerID == GKLocalPlayer.localPlayer().playerID
        })
    }
    
    func matchEnded() {
        
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
