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
        else {
            newPos = position
            let directMoveAction = SKAction.moveTo(newPos, duration: NSTimeInterval(0.7))
            
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
