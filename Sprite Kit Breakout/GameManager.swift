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

    var atlas: SKTextureAtlas!
    var score: Int!
    var lives: Int!
    
    var brickSize: CGSize {
        
        return CGSize(width: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Brick).size().width / UIScreen.mainScreen().scale,
                      height: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Brick).size().height / UIScreen.mainScreen().scale)

    }

    private var view: SKView!
    private init() {}
    
    func initialize(view: SKView) {
        
        self.view = view
        
        self.score = 0
        self.lives = 3
        
        // Preload sound
        SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
        
        self.createTextureAtlas()
        
    }
    
    private func prepareSounds() {
        
        for i in 1...8 {

            SKAction.playSoundFileNamed("bounce_\(i)", waitForCompletion: false)
            
        }
        
        SKAction.playSoundFileNamed("game_over", waitForCompletion: false)
        
    }
    
    private func createTextureAtlas() {
        
        var textures = [String: SKTexture]()
        
        let baseWidth = ceil(self.view.frame.width / GameManager.PlayField.BrickColumns) / 1
        let wallThickness = ceil((baseWidth / 2) * GameManager.PlayField.BrickRows / 3) / 1
        let brickWidth = ceil((self.view.frame.width - (wallThickness * 2)) / GameManager.PlayField.BrickColumns) / 1
        
        // Create texture for bricks
        let tempBrickNode = SKShapeNode(rectOfSize: CGSize(width: brickWidth, height: brickWidth / 2))
        tempBrickNode.antialiased = false
        tempBrickNode.fillColor = UIColor.whiteColor()
        tempBrickNode.strokeColor = UIColor.clearColor()
        
        textures[GameManager.Names.Brick] = self.view.textureFromNode(tempBrickNode, crop: tempBrickNode.frame)
        textures[GameManager.Names.Brick]?.filteringMode = .Nearest
        
        // Create texture for walls
        let tempWallNode = SKShapeNode(rectOfSize: CGSize(width: wallThickness, height: self.view.frame.height / 1.5))
        tempWallNode.antialiased = false
        tempWallNode.fillColor = UIColor.whiteColor()
        tempWallNode.strokeColor = UIColor.clearColor()
        
        textures[GameManager.Names.SideWall] = self.view.textureFromNode(tempWallNode, crop: tempWallNode.frame)
        textures[GameManager.Names.SideWall]?.filteringMode = .Nearest
        
        // Create texture for top
        let tempTopWallNode = SKShapeNode(rectOfSize: CGSize(width: self.view.frame.width, height: wallThickness))
        tempTopWallNode.antialiased = false
        tempTopWallNode.fillColor = UIColor.whiteColor()
        tempTopWallNode.strokeColor = UIColor.clearColor()
        
        textures[GameManager.Names.TopWall] = self.view.textureFromNode(tempTopWallNode, crop: tempTopWallNode.frame)
        textures[GameManager.Names.TopWall]?.filteringMode = .Nearest
        
        // Create texture for player
        let tempPlayerNode = SKShapeNode(rectOfSize: CGSize(width: brickWidth * 2, height: brickWidth / 2))
        tempPlayerNode.antialiased = false
        tempPlayerNode.fillColor = UIColor.whiteColor()
        tempPlayerNode.strokeColor = UIColor.clearColor()
        
        textures[GameManager.Names.Player] = self.view.textureFromNode(tempPlayerNode, crop: tempPlayerNode.frame)
        textures[GameManager.Names.Player]?.filteringMode = .Nearest
        
        // Create texture for ball
        let tempBallNode = SKShapeNode(rectOfSize: CGSize(width: brickWidth / 2, height: brickWidth / 2))
        tempBallNode.antialiased = false
        tempBallNode.fillColor = UIColor.whiteColor()
        tempBallNode.strokeColor = UIColor.clearColor()
        
        textures[GameManager.Names.Ball] = self.view.textureFromNode(tempBallNode, crop: tempBallNode.frame)
        textures[GameManager.Names.Ball]?.filteringMode = .Nearest
        
        // Create texture atlas
        var images = [String: UIImage]()
        
        for (key, texture) in textures {

            images[key] = UIImage(CGImage: texture.CGImage())
            
        }
        
        self.atlas = SKTextureAtlas(dictionary: images)
        
    }
    
    func playSound(named: String) {
        
        self.view.scene!.runAction(SKAction.playSoundFileNamed(named, waitForCompletion: false))
        
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
    
    struct ZOrders {
        
        static let Brick: CGFloat = 1
        static let Wall: CGFloat = 2
        static let Player: CGFloat = 2
        static let Ball: CGFloat = 2
        
    }
    
    struct PlayField {
        
        static let BrickColumns: CGFloat = 14
        static let BrickRows: CGFloat = 6
        
    }
    
    struct Names {
        
        static let Ball = "ball"
        static let Player = "player"
        static let TopWall = "top_wall"
        static let SideWall = "side_wall"
        static let Brick = "brick"
        
    }
    
}