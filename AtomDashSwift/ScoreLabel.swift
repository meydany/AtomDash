//
//  TimeText.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/13/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreLabel: SKLabelNode {

    override init() {
        super.init()
        
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        self.text = "0"
        self.fontName =  "HelveticaNeue-light"
        self.fontSize = 50
        self.fontColor = UIColor.blackColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addScore(points: Int){
        self.text = String(self.text.toInt()! + points)
    }
    
    func removeScore(points: Int){
        if (self.text.toInt()! > 0){
            self.text = String(self.text.toInt()! - points)
        }
    }
    
}