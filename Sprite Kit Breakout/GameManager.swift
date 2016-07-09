//
//  GameManager.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/6/16.
//  Copyright © 2016 Jacob Davis. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameManager {
    
    static let sharedInstance = GameManager()
    
    var view: SKView!

    var atlas: SKTextureAtlas!
    
    var score = 0
    var lives = 3
    
    let brickColumns = 14
    let brickRows = 6
    
    let brickZ: CGFloat = 1
    let wallZ: CGFloat = 2
    let playerZ: CGFloat = 2
    let ballZ: CGFloat = 2
    
    private init() {}
    
    func initialize(view: SKView) {
        
        self.view = view
        
        // Preload sound
        SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
        
        self.createTextureAtlas()
        
    }
    
    private func createTextureAtlas() {
        
        var textures = [String: SKTexture]()
        
        let baseWidth = ceil(self.view.frame.width / CGFloat(self.brickColumns)) / 1
        let wallThickness = ceil((baseWidth / 2) * CGFloat(brickRows / 3)) / 1
        let brickWidth = ceil((self.view.frame.width - (wallThickness * 2)) / CGFloat(self.brickColumns)) / 1
        
        // Create texture for bricks
        let tempBrickNode = SKShapeNode(rectOfSize: CGSize(width: brickWidth, height: brickWidth / 2))
        tempBrickNode.antialiased = false
        tempBrickNode.fillColor = UIColor.whiteColor()
        tempBrickNode.strokeColor = UIColor.clearColor()
        
        textures["brick"] = self.view.textureFromNode(tempBrickNode, crop: tempBrickNode.frame)
        textures["brick"]?.filteringMode = .Nearest
        
        // Create texture for walls
        let tempWallNode = SKShapeNode(rectOfSize: CGSize(width: wallThickness, height: self.view.frame.height / 1.5))
        tempWallNode.antialiased = false
        tempWallNode.fillColor = UIColor.whiteColor()
        tempWallNode.strokeColor = UIColor.clearColor()
        
        textures["sideWall"] = self.view.textureFromNode(tempWallNode, crop: tempWallNode.frame)
        textures["sideWall"]?.filteringMode = .Nearest
        
        // Create texture for top
        let tempTopWallNode = SKShapeNode(rectOfSize: CGSize(width: self.view.frame.width, height: wallThickness))
        tempTopWallNode.antialiased = false
        tempTopWallNode.fillColor = UIColor.whiteColor()
        tempTopWallNode.strokeColor = UIColor.clearColor()
        
        textures["topWall"] = self.view.textureFromNode(tempTopWallNode, crop: tempTopWallNode.frame)
        textures["topWall"]?.filteringMode = .Nearest
        
        // Create texture for player
        let tempPlayerNode = SKShapeNode(rectOfSize: CGSize(width: brickWidth * 2, height: brickWidth / 2))
        tempPlayerNode.antialiased = false
        tempPlayerNode.fillColor = UIColor.whiteColor()
        tempPlayerNode.strokeColor = UIColor.clearColor()
        
        textures["player"] = self.view.textureFromNode(tempPlayerNode, crop: tempPlayerNode.frame)
        textures["player"]?.filteringMode = .Nearest
        
        // Create texture for ball
        let tempBallNode = SKShapeNode(rectOfSize: CGSize(width: brickWidth / 2, height: brickWidth / 2))
        tempBallNode.antialiased = false
        tempBallNode.fillColor = UIColor.whiteColor()
        tempBallNode.strokeColor = UIColor.clearColor()
        
        textures["ball"] = self.view.textureFromNode(tempBallNode, crop: tempBallNode.frame)
        textures["ball"]?.filteringMode = .Nearest
        
        // Create texture atlas
        var images = [String: UIImage]()
        
        for (key, texture) in textures {

            images[key] = UIImage(CGImage: texture.CGImage())
            
        }
        
        self.atlas = SKTextureAtlas(dictionary: images)
        
    }
    
    struct Color {
        
        static let Blue = UIColor(red: 41/255, green: 173/255, blue: 255/255, alpha: 1)
        static let Green = UIColor(red: 0/255, green: 228/255, blue: 54/255, alpha: 1)
        static let Yellow = UIColor(red: 255/255, green: 236/255, blue: 39/255, alpha: 1)
        static let Orange = UIColor(red: 255/255, green: 136/255, blue: 0/255, alpha: 1)
        static let Red = UIColor(red: 255/255, green: 0/255, blue: 77/255, alpha: 1)
        static let Pink = UIColor(red: 255/255, green: 119/255, blue: 168/255, alpha: 1)
        static let LightGray = UIColor(red: 194/255, green: 195/255, blue: 199/255, alpha: 1)
        static let Purple = UIColor(red: 131/255, green: 118/255, blue: 156/255, alpha: 1)
        
    }
    
}