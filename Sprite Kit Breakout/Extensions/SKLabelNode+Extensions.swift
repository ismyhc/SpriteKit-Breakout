//
//  SKLabelNode+Extensions.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/12/16.
//  Copyright © 2016 Jacob Davis. All rights reserved.
//

import SpriteKit

extension SKLabelNode {
    
    func adjustLabelFontSizeToFitHeight(height: CGFloat) {

        let scalingFactor = floor(height / self.frame.height)
        self.fontSize *= scalingFactor
        
    }
    
}
