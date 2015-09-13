//
//  GameViewController.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

extension UILabel {
    
    func startCountdown(seconds: Int){
        self.text = String(seconds)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdown"), userInfo: nil, repeats: true)
    }
    
    func countdown() {
        if (self.text!.toInt()! > 0){
            self.text = String(self.text!.toInt()!-1)
        }
    }
}

class GameViewController: UIViewController {
<<<<<<< HEAD
    
=======
            
>>>>>>> 56013eb34488774d4597860074789f42cee234d1
    var timeLabel: UILabel?
    var scoreLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
<<<<<<< HEAD
            // Creating the TimeLabel
=======
            // Creating a TimeLabel
>>>>>>> 56013eb34488774d4597860074789f42cee234d1
            timeLabel = UILabel(frame: CGRectMake(0, 0, skView.frame.width/4, skView.frame.height/10))
            timeLabel!.textAlignment = NSTextAlignment.Center
            timeLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
            timeLabel!.textColor = UIColor.blackColor()
            self.view.addSubview(timeLabel!)
            timeLabel!.startCountdown(10)
<<<<<<< HEAD
            
            // Creating the ScoreLabel
            scoreLabel = UILabel(frame: CGRectMake(100, 0, skView.frame.width/4, skView.frame.height/10))
            scoreLabel!.text = "0"
            scoreLabel!.textAlignment = NSTextAlignment.Center
            scoreLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
            scoreLabel!.textColor = UIColor.blackColor()
            self.view.addSubview(scoreLabel!)
            
=======
            
            // Creating a ScoreLabel
            scoreLabel = UILabel(frame: CGRectMake(100, 0, skView.frame.width/4, skView.frame.height/10))
            scoreLabel!.text = "0"
            scoreLabel!.textAlignment = NSTextAlignment.Center
            scoreLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
            scoreLabel!.textColor = UIColor.blackColor()
            self.view.addSubview(scoreLabel!)
>>>>>>> 56013eb34488774d4597860074789f42cee234d1
            
            skView.presentScene(scene)
        }
    }
    
    func addScore(points: Int){
       scoreLabel!.addScore(points)
    }
    
    func removeScore(points: Int){
        scoreLabel!.removeScore(points)
    }

    func addScore (points: Int){
        scoreLabel!.addScore(points)
    }
    
    func removeScore (points: Int){
        scoreLabel!.removeScore(points)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
