//
//  PlayerNode.swift
//  GameplayKit Introduction
//
//  Created by Davis Allie on 19/07/2015.
//  Copyright © 2015 Davis Allie. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PlayerNode: SKShapeNode {
    
    var enabled = true {
        didSet {
            if self.enabled == false {
                self.alpha = 0.1
                
                self.run(SKAction.customAction(withDuration: 2.0, actionBlock: { (node, elapsedTime) -> Void in
                    if elapsedTime == 2.0 {
                        self.enabled = true
                    }
                }))
                
                self.run(SKAction.fadeIn(withDuration: 2.0))
            }
        }
    }
}
