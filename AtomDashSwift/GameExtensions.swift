//
//  SKNodeExtension .swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/12/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    
    enum MoveType {
        case Smooth
        case Direct
    }
    
    func moveToPosition(position: CGPoint, moveType: MoveType?) {
        var newPos: CGPoint
        if(moveType == MoveType.Smooth) {
            let currentPos = self.position
            let newPos = position
            
            let xDifference = CGFloat(newPos.x - currentPos.x)
            let yDifference = CGFloat(newPos.y - currentPos.y)
            
            self.physicsBody?.velocity = CGVector(dx: xDifference, dy: yDifference)
        }
        else if (moveType == MoveType.Direct){
            newPos = position
            let directMoveAction = SKAction.moveTo(newPos, duration: NSTimeInterval(0.5))
            
            self.runAction(directMoveAction)
        }
    }
    
    func moveToRandomPosition(frame: CGRect) {
        self.position = getRandomPosition(frame)
    }
    
    func getRandomPosition(frame: CGRect) -> CGPoint {
        let maxX = CGRectGetMaxX(frame)
        let maxY = CGRectGetMaxY(frame)
        
        let xOffset = self.frame.width/2
        let yOffset = self.frame.height/2
        
        let randomX = CGFloat(Int(arc4random_uniform(UInt32(maxX - (2 * xOffset)))) + Int(xOffset))
        let randomY = CGFloat(Int(arc4random_uniform(UInt32(maxY - (2 * yOffset)))) + Int(yOffset))
        
        let randomPos = CGPoint(x: randomX, y: randomY)
        
        return randomPos
    }
}

extension UIColor {
    class func gameBlueColor() -> UIColor {
        return UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1)
    }
    
    class func gameRedColor() -> UIColor {
        return UIColor(red: 0.94, green: 0.55, blue: 0.55, alpha: 1)
    }
    
    class func gameGreenColor() -> UIColor {
        return UIColor(red: 0.59, green: 0.89, blue: 0.56, alpha: 1)
    }
    
    class func gamePurpleColor() -> UIColor {
        return UIColor(red: 0.87, green: 0.8, blue: 0.93, alpha: 1)
    }
    
    class func gameGoldColor() -> UIColor {
        return UIColor(red: 1.0, green: 0.95, blue: 0.45, alpha: 1)
    }
}

extension Int
{
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

