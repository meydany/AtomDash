//
//  GameOverScene.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import UIKit

class GameOverViewController: UIViewController {
    
    var gameOverLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverLabel = UILabel(frame: CGRectMake(0, 0, 100, 20))
        gameOverLabel!.text = "deez nuts"
    }
    
    
    /*
    scoreLabel = UILabel(frame: CGRectMake(0, 0, skView.frame.width * 2 - (skView.frame.width/4), skView.frame.height/10))
    scoreLabel!.text = "0"
    scoreLabel!.textAlignment = NSTextAlignment.Center
    scoreLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
    scoreLabel!.textColor = UIColor.blackColor()
    self.view.addSubview(scoreLabel!)
    */
    
}