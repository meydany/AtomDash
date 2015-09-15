//
//  ScoreLabel.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/14/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import UIKit

class TimeLabel: UILabel{
    
    var isTimeUp: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //class func
    func startCountdown(seconds: Int){
        isTimeUp = false
        self.text = String(seconds)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdown"), userInfo: nil, repeats: true)
    }
    
    func countdown() {
        if (self.text!.toInt()! > 0){
            self.text = String(self.text!.toInt()!-1)
        }
        else {
            isTimeUp = true
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}