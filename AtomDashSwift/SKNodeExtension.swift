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
    
    enum ColliderObject: UInt32 {
        case wallCollider = 1
        case playerCollider = 2
        case targetCollider = 4
        case enemyCollider = 6
    }
    
    enum MoveType {
        case Smooth
        case Direct
    }
    
    func moveToPosition(position: CGPoint, moveType: MoveType?) {
        if(moveType == MoveType.Smooth) {
            var currentPos = self.position
            var newPos = position
            
            var xDifference = CGFloat(newPos.x - currentPos.x)
            var yDifference = CGFloat(newPos.y - currentPos.y)
            
            self.physicsBody?.velocity = CGVector(dx: xDifference, dy: yDifference)
        }else {
            var newPos = position
            var directMoveAction = SKAction.moveTo(newPos, duration: NSTimeInterval(0.7))
            
            self.runAction(directMoveAction)
        }
    }
    
    func moveToRandomPosition(frame: CGRect) {
        self.position = getRandomPosition(frame)
    }
    
    func getRandomPosition(frame: CGRect) -> CGPoint {
        var maxX = CGRectGetMaxX(frame)
        var maxY = CGRectGetMaxY(frame)
        
        var xOffset = self.frame.width/2
        var yOffset = self.frame.height/2
        
        var randomX = CGFloat(Int(arc4random_uniform(UInt32(maxX - (2 * xOffset)))) + Int(xOffset))
        var randomY = CGFloat(Int(arc4random_uniform(UInt32(maxY - (2 * yOffset)))) + Int(yOffset))
        
        var randomPos = CGPoint(x: randomX, y: randomY)
        
        return randomPos
    }
}
