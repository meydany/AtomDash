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

    func addScore(points: Int){
        self.text = String(self.text.toInt()! + points)
    }
    
    func removeScore(points: Int){
        if (self.text.toInt()! > 0){
            self.text = String(self.text.toInt()! - points)
        }
    }
    
}