//
//  MultiplayerInstructionsScene.swift
//  AtomDash
//
//  Created by Yoli Meydan on 10/6/15.
//  Copyright © 2015 SoyMobile. All rights reserved.
//

import Foundation
import SpriteKit

class MultiplayerInstructionsScene: SKScene, UIScrollViewDelegate{
    
    var firstLabelView: UITextView!
    var secondLabelView: UITextView!
    var thirdLabelView: UITextView!
    var fourthLabelView: UITextView!
    
    var gotItButton: UIButton!
    var buttonView: UIView!
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var currentScrollPoint = CGPoint!()
    
    var slides: Int!
    
    var removeSubviews: Bool!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.whiteColor()
        
        currentScrollPoint = CGPoint(x: 0,y: 0)
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        scrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        scrollView.contentSize = CGSize(width: view.frame.width * 4, height: view.frame.height)
        scrollView.alpha = 0
        
        pageControl = UIPageControl(frame: CGRectMake((3*view.frame.width)/8,view.frame.height/1.25,scrollView.frame.width/4, scrollView.frame.height/8))
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.redColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.grayColor()
        pageControl.alpha = 0
        
        slides = Int()
        slides = 0
        
        firstLabelView = makeTextView("You are the ", part2: "BLUE", color: UIColor.gameBlueColor())
        secondLabelView = makeTextView("They are the ", part2: "PURPLE", color: UIColor.gamePurpleColor())
        thirdLabelView = makeTextView("Avoid the ", part2: "RED", color: UIColor.gameRedColor())
        fourthLabelView = makeTextView("Get the ", part2: "GREEN", color: UIColor.gameGreenColor())
        
        
        //Button frame
        gotItButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width/2.5, height: self.frame.width/7))
        gotItButton.frame.origin = CGPoint(x: (self.frame.midX)*7 - gotItButton.frame.width/2, y: self.frame.height/1.5)
        gotItButton.layer.cornerRadius = 10
        gotItButton.backgroundColor = UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1)
        gotItButton.setTitle("GOT IT", forState: UIControlState.Normal)
        gotItButton.addTarget(self, action: "presentInstructionsScene", forControlEvents: UIControlEvents.TouchUpInside)
        
        let scalingFactor = min(self.frame.width / gotItButton.frame.width, self.frame.height / gotItButton.frame.height)/1.25
        gotItButton.titleLabel!.font = UIFont(name: "DINCondensed-Bold", size: gotItButton.titleLabel!.font.pointSize * CGFloat(scalingFactor))
        gotItButton.titleLabel!.textAlignment = NSTextAlignment.Center
        gotItButton.contentEdgeInsets = UIEdgeInsets(top: gotItButton.frame.height/5, left: 0, bottom: 0, right: 0)
        
        removeSubviews = false
        
        scrollView.addSubview(firstLabelView)
        scrollView.addSubview(secondLabelView)
        scrollView.addSubview(thirdLabelView)
        scrollView.addSubview(fourthLabelView)
        scrollView.addSubview(gotItButton)
        
        self.view?.addSubview(scrollView)
        self.view?.addSubview(pageControl)
        fadeInViews()
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(removeSubviews!) {
            runAction(SKAction.waitForDuration(0.1), completion: {self.pageControl.removeFromSuperview()})
            runAction(SKAction.waitForDuration(0.1), completion: {self.scrollView.removeFromSuperview()})
            removeSubviews = false
        }
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
        textView.font = UIFont(name: "DINCondensed-Bold", size: 50 * Screen.screenWidthRatio)
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
    
    func presentInstructionsScene() {
        fadeOutViews()
        let chooseScene = ChooseMultiplayerConnectionType(size: self.scene!.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.7)
        self.view?.presentScene(chooseScene, transition: transition)
    }
    
    func fadeInViews() {
        UIView.animateWithDuration(0.7, animations: {
            self.pageControl.alpha = 1
            self.scrollView.alpha = 1
        })
    }
    
    func fadeOutViews() {
        UIView.animateWithDuration(0.4, animations: {
            self.pageControl.alpha = 0
            self.scrollView.alpha = 0
        })
        removeSubviews = true
    }
    
}