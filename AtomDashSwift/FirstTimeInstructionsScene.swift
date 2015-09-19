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
    
    var scrollView: UIScrollView!
    
    override func didMoveToView(view: SKView) {
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        
        firstLabelView = UITextView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        firstLabelView.attributedText = createAttributedString("You are the ", secondPart: "BLUE", color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        firstLabelView.font = UIFont(name: "DINCondensed-Bold", size: 50)
        firstLabelView.textAlignment = NSTextAlignment.Center
        firstLabelView.editable = false
        firstLabelView.contentOffset = CGPoint(x: 0, y: -view.frame.height/4)
        
        secondLabelView = UITextView(frame: CGRectMake(view.frame.width, 0, view.frame.width, view.frame.height))
        secondLabelView.attributedText = createAttributedString("Avoid the ", secondPart: "RED", color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        secondLabelView.font = UIFont(name: "DINCondensed-Bold", size: 50)
        secondLabelView.textAlignment = NSTextAlignment.Center
        secondLabelView.editable = false
        secondLabelView.contentOffset = CGPoint(x: 0, y: -view.frame.height/4)
        
        scrollView?.contentSize = CGSize(width: view.frame.width*2, height: view.frame.height)
        
        scrollView.addSubview(firstLabelView)
        scrollView.addSubview(secondLabelView)
        self.view?.addSubview(scrollView!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches as Set<UITouch>) {
            let location = touch.locationInNode(self)
            
        }
    }
    
    func createAttributedString(firstPart: String, secondPart: String, color: UIColor) -> NSMutableAttributedString {
        let stringPartOne = NSMutableAttributedString(string: firstPart)
        let stringPartTwo = NSMutableAttributedString(string: secondPart, attributes: [NSForegroundColorAttributeName: color])
        stringPartOne.appendAttributedString(stringPartTwo)
        return stringPartOne
    }
    
}