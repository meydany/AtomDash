//
//  TimeText.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/13/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import UIKit

class TimeLabel: UILabel {
    
    var time: Int?
  
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func startCountdown(seconds: Int){
        self.time = seconds
        updateLabel()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)

    }
    
    func updateLabel(){
        self.text = String("Hello")
        println("Updating time") //for testing purposes
    }
}