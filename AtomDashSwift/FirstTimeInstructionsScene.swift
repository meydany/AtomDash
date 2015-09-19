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
    
    // Counts the amount of slides we will have, helps for optimization
    var slides: Int?
    
    var scrollView: UIScrollView!
    
    override func didMoveToView(view: SKView) {
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        
        slides = Int()
        slides! = 0
        
        firstLabelView = makeTextView("You are the ", part2: "BLUE", color: UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1))
        secondLabelView = makeTextView("Avoid the ", part2: "RED", color: UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1))
        thirdLabelView = makeTextView("Get the ", part2: "GREEN", color: UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1))
        
        scrollView?.contentSize = CGSize(width: view.frame.width * CGFloat(slides!), height: view.frame.height)
        
        scrollView.addSubview(firstLabelView)
        scrollView.addSubview(secondLabelView)
        scrollView.addSubview(thirdLabelView)
        self.view?.addSubview(scrollView!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches as Set<UITouch>) {
            _ = touch.locationInNode(self)
            
        }
    }
    
    func makeTextView(part1: String, part2: String, color: UIColor) -> UITextView{
        
        let textView = UITextView(frame: CGRectMake(CGFloat(slides!) * self.frame.width, 0, self.frame.width, self.frame.height))
        textView.attributedText = createAttributedString(part1, secondPart: part2, color: color)
        textView.font = UIFont(name: "DINCondensed-Bold", size: 50)
        textView.textAlignment = NSTextAlignment.Center
        textView.editable = false
        textView.contentOffset = CGPoint(x: 0, y: -self.frame.height/4)
        
        slides! = slides! + 1
        
        return textView
    }
    
    func createAttributedString(firstPart: String, secondPart: String, color: UIColor) -> NSMutableAttributedString {
        let stringPartOne = NSMutableAttributedString(string: firstPart)
        let stringPartTwo = NSMutableAttributedString(string: secondPart, attributes: [NSForegroundColorAttributeName: color])
        stringPartOne.appendAttributedString(stringPartTwo)
        return stringPartOne
    }
    
}