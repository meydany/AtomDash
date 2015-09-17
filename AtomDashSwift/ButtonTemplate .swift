//
//  ButtonTemplate .swift
//  AtomDashSwift
//
//  Created by Yoli Meydan on 9/16/15.
//  Copyright (c) 2015 MilkyShakeMobile. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonTemplate: SKShapeNode {
    init(name: String, size: CGSize, position: CGPoint) {
        super.init()
        
        var rect = CGRect(origin: CGPointZero, size: size)
        self.path = CGPathCreateWithRoundedRect(rect, CGFloat(10), CGFloat(10), nil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
