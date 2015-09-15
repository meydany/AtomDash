//
//  MenuScene.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        self.size = view.bounds.size
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}