//
//  GameOverScene.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import SpriteKit
import UIKit

class GameOverScene: SKScene {
    
    var gameOverLabel: SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        
    }
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverLabel = UILabel(frame: CGRectMake(0, 0, 100, 20))
        gameOverLabel!.text = "deez nuts"
        
        self.view!.addSubview(gameOverLabel!)
    }
    */
}