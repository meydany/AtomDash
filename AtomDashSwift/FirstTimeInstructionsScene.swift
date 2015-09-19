//
//  FirstTimeInstructionsScene.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/17/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class FirstTimeInstructionsScene: SKScene {
    
    var firstLabelView: UITextView!
    var secondLabelView: UITextView!
    var thirdLabelView: UITextView!
    
    var scrollView: UIScrollView?
    
    override func didMoveToView(view: SKView) {
        scrollView = UIScrollView(frame: view.frame)
        scrollView?.backgroundColor = UIColor.whiteColor()
        
        firstLabelView = UITextView(frame: scrollView!.frame)
        let firstPartOne = NSMutableAttributedString(string: "You are the ")
        let firstPartTwo = NSMutableAttributedString(string: "BLUE", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1)])
        firstPartOne.appendAttributedString(firstPartTwo)
        
        firstLabelView.attributedText = firstPartOne
        firstLabelView.font = UIFont(name: "DINCondensed-Bold", size: 50)
        firstLabelView.contentOffset = CGPoint(x: -view.frame.width/7, y: -view.frame.height/4)
        print(firstLabelView.contentOffset)
        
        scrollView?.addSubview(firstLabelView)
        self.view?.addSubview(scrollView!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches as Set<UITouch>) {
            let location = touch.locationInNode(self)
            
        }
    }
    
}