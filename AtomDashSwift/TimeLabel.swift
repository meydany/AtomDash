//
//  ScoreLabel.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class TimeLabel: SKLabelNode{
    
    var isTimeUp: Bool = false
    
    override init() {
        super.init()
        
        //Sets the origin of the node to be the top left corner, makes it easier to position it
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        
        self.fontName = "HelveticaNeue-light"
        self.fontSize = 50
        self.fontColor = UIColor.blackColor()
    }
    
    //class func
    func startCountdown(seconds: Int){
        isTimeUp = false
        self.text = String(seconds)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdown"), userInfo: nil, repeats: true)
    }
    
    func countdown() {
        if (self.text.toInt()! > 0){
            self.text = String(self.text.toInt()!-1)
        }
        else {
            isTimeUp = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}