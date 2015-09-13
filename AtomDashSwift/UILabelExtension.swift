//
//  TimeText.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/13/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    // For TimerLabel
    func startCountdown(seconds: Int){
        self.text = String(seconds)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdown"), userInfo: nil, repeats: true)
    }
    
    func countdown() {
        if (self.text!.toInt()! > 0){
            self.text = String(self.text!.toInt()!-1)
        }
    }
    
    // For ScoreLabel
    func addScore(points: Int){
        self.text = String(self.text!.toInt()! + points)
    }
    
    func removeScore(points: Int){
        self.text = String(self.text!.toInt()! - points)
    }
}