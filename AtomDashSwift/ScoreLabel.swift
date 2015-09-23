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
        
        //Sets the origin of the node to be the top right corner, makes it easier to position it
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        
        self.text = "0"
        self.fontName = "HelveticaNeue-Thin"
        self.fontSize = 75
        self.fontColor = UIColor.darkGrayColor()
    }
    
    func addScore(points: Int){
        self.text = String(Int(self.text!)! + points)
    }
    
    func removeScore(points: Int){
        if (Int(self.text!)! > 0){
            self.text = String(Int(self.text!)! - points)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}