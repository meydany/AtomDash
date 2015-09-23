//
//  FirstTimeInstructionsScene.swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/17/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class FirstTimeInstructionsScene: SKScene, UIScrollViewDelegate{
    
    var firstLabelView: UITextView!
    var secondLabelView: UITextView!
    var thirdLabelView: UITextView!
    
    var gotItButton: UIButton!
    var buttonView: UIView!
    
    var scrollView: UIScrollView!
    var currentScrollPoint = CGPoint!()
    var pageControl: UIPageControl!
    
    var slides: Int!
    
    override func didMoveToView(view: SKView) {
        
        currentScrollPoint = CGPoint(x: 0,y: 0)
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height)
        
        pageControl = UIPageControl(frame: CGRectMake((3*view.frame.width)/8,view.frame.height/1.25,scrollView.frame.width/4, scrollView.frame.height/8))
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.redColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.grayColor()

        slides = Int()
        slides = 0
        
        firstLabelView = makeTextView("You are the ", part2: "BLUE", color: UIColor.gameBlueColor())
        secondLabelView = makeTextView("Avoid the ", part2: "RED", color: UIColor.gameRedColor())
        thirdLabelView = makeTextView("Get the ", part2: "GREEN", color: UIColor.gameGreenColor())

        //Button frame
        gotItButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width/2.5, height: self.frame.width/8))
        gotItButton.frame.origin = CGPoint(x: (self.frame.midX)*5 - gotItButton.frame.width/2, y: self.frame.height/1.5)
        gotItButton.layer.cornerRadius = 10
        
        //Button background and title
        gotItButton.backgroundColor = UIColor.gameGreenColor()
        gotItButton.setTitle("GOT IT", forState: UIControlState.Normal)
        gotItButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        //Button text
        let scalingFactor = min(self.frame.width / gotItButton.frame.width, self.frame.height / gotItButton.frame.height)/1.25
        gotItButton.titleLabel!.font = UIFont(name: "DINCondensed-Bold", size: gotItButton.titleLabel!.font.pointSize * CGFloat(scalingFactor))
        gotItButton.titleLabel!.textAlignment = NSTextAlignment.Center
        gotItButton.contentEdgeInsets = UIEdgeInsets(top: gotItButton.frame.height/5, left: 0, bottom: 0, right: 0)
        
        //Button event
        gotItButton.addTarget(self, action: "presentPlayScene", forControlEvents: UIControlEvents.TouchUpInside)

        scrollView.addSubview(firstLabelView)
        scrollView.addSubview(secondLabelView)
        scrollView.addSubview(thirdLabelView)
        scrollView.addSubview(gotItButton)
        
        self.view?.addSubview(scrollView!)
        self.view?.addSubview(pageControl)

    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        currentScrollPoint.x = scrollView.contentOffset.x
        currentScrollPoint.y = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (currentScrollPoint.x > scrollView.contentOffset.x) {
            pageControl.currentPage--
        }else if (currentScrollPoint.x < scrollView.contentOffset.x) {
            pageControl.currentPage++
        }
    }
    
    func makeTextView(part1: String, part2: String, color: UIColor) -> UITextView{
        
        let textView = UITextView(frame: CGRectMake(CGFloat(slides!) * self.frame.width, 0, self.frame.width, self.frame.height))
        textView.attributedText = createAttributedString(part1, secondPart: part2, color: color)
        textView.font = UIFont(name: "DINCondensed-Bold", size: 50)
        textView.textAlignment = NSTextAlignment.Center
        textView.editable = false
        textView.contentOffset = CGPoint(x: 0, y: -self.frame.height/4)
        
        slides = slides + 1
        
        return textView
    }
    
    func createAttributedString(firstPart: String, secondPart: String, color: UIColor) -> NSMutableAttributedString {
        let stringPartOne = NSMutableAttributedString(string: firstPart, attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        let stringPartTwo = NSMutableAttributedString(string: secondPart, attributes: [NSForegroundColorAttributeName: color])
        stringPartOne.appendAttributedString(stringPartTwo)
        return stringPartOne
    }
    
    func presentPlayScene() {
        scrollView.removeFromSuperview()
        pageControl.removeFromSuperview()
        let playScene = PlayScene(size: self.scene!.size)
        self.scene!.view?.presentScene(playScene)
    }
    
}