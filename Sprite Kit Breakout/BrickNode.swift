//
//  BrickNode.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/7/16.
//  Copyright © 2016 Jacob Davis. All rights reserved.
//

import SpriteKit

enum BrickRow {
    case One, Two, Three, Four, Five, Six
}

struct BrickData {
    
    var points: Int
    var brickRow: BrickRow
    var color: UIColor
    var collectable: Bool
    
}

class BrickNode: SKSpriteNode {
    
    var brickData: BrickData! {
        
        didSet {
            
            self.color = brickData.color
            self.colorBlendFactor = 1
            self.anchorPoint = CGPointZero
            self.setScale(1 / UIScreen.mainScreen().scale)
            self.zPosition = GameManager.sharedInstance.brickZ
            self.name = "brick"
            
        }
        
    }
    
    convenience init() {
        
        let texture = GameManager.sharedInstance.atlas.textureNamed("brick")
        let size = CGSize(width: texture.size().width, height: texture.size().height)

        self.init(texture: texture, color: UIColor.whiteColor(), size: size)

    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
