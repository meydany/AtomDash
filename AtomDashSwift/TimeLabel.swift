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
    
    var redValue: CGFloat?
    
    override init() {
        super.init()
        
        redValue = 0
        
        //Sets the origin of the node to be the top left corner, makes it easier to position it
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        
        self.fontName = "DINCondensed-Bold"
        self.fontSize = 75
        self.fontColor = UIColor(red: redValue!, green: 0, blue: 0, alpha: 1)
    }
    
    //class func
    func startCountdown(seconds: Int){
        isTimeUp = false
        self.text = String(seconds)
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(1),SKAction.runBlock(countdown)])))
    }
    
    func countdown() {
        if (self.text.toInt()! > 0){
            self.text = String(self.text.toInt()!-1)
            
            redValue = redValue! + CGFloat(1.0/CGFloat(self.text.toInt()!))
            println(redValue)
            
            self.fontColor = UIColor(red: redValue!, green: 0, blue: 0, alpha: 1)
        }
        else {
            isTimeUp = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}