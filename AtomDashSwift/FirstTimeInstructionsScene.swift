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
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        scrollView?.backgroundColor = UIColor.whiteColor()
        scrollView!.directionalLockEnabled = true
        scrollView!.pagingEnabled = true
        
        firstLabelView = UITextView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        let firstPartOne = NSMutableAttributedString(string: "You are the ")
        let firstPartTwo = NSMutableAttributedString(string: "BLUE", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1)])
        firstPartOne.appendAttributedString(firstPartTwo)
        
        firstLabelView.attributedText = firstPartOne
        firstLabelView.font = UIFont(name: "DINCondensed-Bold", size: 50)
        firstLabelView.contentOffset = CGPoint(x: -view.frame.width/7, y: -view.frame.height/4)
        
        secondLabelView = UITextView(frame: CGRectMake(view.frame.width, 0, view.frame.width, view.frame.height))
        let secondPartOne = NSMutableAttributedString(string: "Avoid the ")
        let secondPartTwo = NSMutableAttributedString(string: "RED", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1)])
        secondPartOne.appendAttributedString(secondPartTwo)
        
        secondLabelView.attributedText = secondPartOne
        secondLabelView.font = UIFont(name: "DINCondensed-Bold", size: 50)
        secondLabelView.contentOffset = CGPoint(x: -view.frame.width/7, y: -view.frame.height/4)
        
        scrollView?.contentSize = CGSize(width: view.frame.width*2, height: view.frame.height)
        
        scrollView!.addSubview(firstLabelView)
        scrollView!.addSubview(secondLabelView)
        self.view?.addSubview(scrollView!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches as Set<UITouch>) {
            let location = touch.locationInNode(self)
            
        }
    }
    
}