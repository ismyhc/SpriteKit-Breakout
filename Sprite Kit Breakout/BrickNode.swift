//
//  BrickNode.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/7/16.
//  Copyright © 2016 Jacob Davis. All rights reserved.
//

import SpriteKit

enum BrickRow {
    case one, two, three, four, five, six
}

struct BrickData {
    
    var points: Int
    var brickRow: BrickRow
    var color: UIColor
    var collectable: Bool
    var soundName: String
    var ballSpeedModifier: CGFloat
    
}

class BrickNode: SKSpriteNode {
    
    var brickData: BrickData! {
        
        didSet {
            
            self.color = brickData.color
            self.colorBlendFactor = 1
            self.anchorPoint = CGPoint.zero
            self.setScale(1 / UIScreen.main.scale)
            self.zPosition = GameManager.ZOrders.Brick
            self.name = GameManager.Names.Brick
            
        }
        
    }
    
    convenience init() {
        
        let texture = GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Brick)
        let size = CGSize(width: texture.size().width, height: texture.size().height)

        self.init(texture: texture, color: UIColor.white, size: size)

    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
