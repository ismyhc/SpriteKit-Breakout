//
//  BallNode.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/6/16.
//  Copyright © 2016 Jacob Davis. All rights reserved.
//

import SpriteKit


class BallNode: SKSpriteNode {
    
    var move: vector_float2!
    var moveSpeed: CGFloat!
    
    var enabled = false {
        
        didSet {
            if enabled {
                
                self.hidden = false
                
            } else {
                
                self.hidden = true
            }
            
        }
    }
    
}
