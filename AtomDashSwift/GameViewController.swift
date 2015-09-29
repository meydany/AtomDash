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

class GameViewController: UIViewController, GCHelperDelegate{
    
    var menuScene: SKScene!
    var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GameViewController"
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.multipleTouchEnabled = false
        
        menuScene = MenuScene(size: skView.bounds.size)

        /* Set the scale mode to scale to fit the window */
        menuScene!.scaleMode = .AspectFill
        
        skView.presentScene(menuScene!)
    }
    
    func matchStarted(){
    
    }
    
    /// Method called when the device received data about the match from another device in the match.
    func match(match: GKMatch, didReceiveData: NSData, fromPlayer: String){
        print("match Connected")
    }
    
    /// Method called when the match has ended.
    func matchEnded(){
    
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
