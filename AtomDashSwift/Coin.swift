//
//  Coin.swift
//  AtomDash
//
//  Created by Yoli Meydan on 10/27/15.
//  Copyright © 2015 SoyMobile. All rights reserved.
//

import Foundation
import SpriteKit

class Coin : SKShapeNode {
    
    override init() {
        super.init()
        
        self.name = "Coin"
        
        let mutablePath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(mutablePath, nil, 0, 0, CGFloat(10 * Screen.screenWidthRatio), CGFloat(0), CGFloat(M_PI*2), true)
        self.path = mutablePath
        self.lineWidth = 4 * Screen.screenWidthRatio
        self.strokeColor = UIColor.gameGoldColor()
        self.alpha = 0
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = false
        
        self.physicsBody!.categoryBitMask = ColliderObject.coinCollider.rawValue
        self.physicsBody!.contactTestBitMask = ColliderObject.playerCollider.rawValue
    }
    
    func destroyCoin() {
        let destroyTime = Int.random(2...3)

        runAction(SKAction.sequence([SKAction.waitForDuration(NSTimeInterval(destroyTime)), SKAction.fadeOutWithDuration(0.1)]), completion: {
            self.removeFromParent()
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

