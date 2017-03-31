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
        
        return CGSize(width: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Brick).size().width / UIScreen.main.scale,
                      height: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Brick).size().height / UIScreen.main.scale)

    }

    fileprivate var view: SKView!
    fileprivate init() {}
    
    func initialize(_ view: SKView) {
        
        self.view = view
        
        self.score = 0
        self.lives = 3
        
        // Preload sound
        SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
        self.prepareSounds()
        
        self.createTextureAtlas()
        
    }
    
    fileprivate func prepareSounds() {
        
        for i in 1...8 {

            SKAction.playSoundFileNamed("bounce_\(i)", waitForCompletion: false)
            
        }
        
        SKAction.playSoundFileNamed("game_over", waitForCompletion: false)
        
    }

    fileprivate func createTextureAtlas() {
        
        var textures = [String: SKTexture]()
        
        let baseWidth = ceil(self.view.frame.width / GameManager.PlayField.BrickColumns) / 1
        let wallThickness = ceil((baseWidth / 2) * GameManager.PlayField.BrickRows / 3) / 1
        let brickWidth = ceil((self.view.frame.width - (wallThickness * 2)) / GameManager.PlayField.BrickColumns) / 1
        
        // Create texture for bricks
        let tempBrickNode = SKShapeNode(rectOf: CGSize(width: brickWidth, height: brickWidth / 2))
        tempBrickNode.isAntialiased = false
        tempBrickNode.fillColor = UIColor.white
        tempBrickNode.strokeColor = UIColor.clear
        
        textures[GameManager.Names.Brick] = self.view.texture(from: tempBrickNode, crop: tempBrickNode.frame)
        textures[GameManager.Names.Brick]?.filteringMode = .nearest
        
        // Create texture for walls
        let tempWallNode = SKShapeNode(rectOf: CGSize(width: wallThickness, height: self.view.frame.height / 1.5))
        tempWallNode.isAntialiased = false
        tempWallNode.fillColor = UIColor.white
        tempWallNode.strokeColor = UIColor.clear
        
        textures[GameManager.Names.SideWall] = self.view.texture(from: tempWallNode, crop: tempWallNode.frame)
        textures[GameManager.Names.SideWall]?.filteringMode = .nearest
        
        // Create texture for top
        let tempTopWallNode = SKShapeNode(rectOf: CGSize(width: self.view.frame.width, height: wallThickness))
        tempTopWallNode.isAntialiased = false
        tempTopWallNode.fillColor = UIColor.white
        tempTopWallNode.strokeColor = UIColor.clear
        
        textures[GameManager.Names.TopWall] = self.view.texture(from: tempTopWallNode, crop: tempTopWallNode.frame)
        textures[GameManager.Names.TopWall]?.filteringMode = .nearest
        
        // Create texture for player
        let tempPlayerNode = SKShapeNode(rectOf: CGSize(width: brickWidth * 2, height: brickWidth / 2))
        tempPlayerNode.isAntialiased = false
        tempPlayerNode.fillColor = UIColor.white
        tempPlayerNode.strokeColor = UIColor.clear
        
        textures[GameManager.Names.Player] = self.view.texture(from: tempPlayerNode, crop: tempPlayerNode.frame)
        textures[GameManager.Names.Player]?.filteringMode = .nearest
        
        // Create texture for ball
        let tempBallNode = SKShapeNode(rectOf: CGSize(width: brickWidth / 2, height: brickWidth / 2))
        tempBallNode.isAntialiased = false
        tempBallNode.fillColor = UIColor.white
        tempBallNode.strokeColor = UIColor.clear
        
        textures[GameManager.Names.Ball] = self.view.texture(from: tempBallNode, crop: tempBallNode.frame)
        textures[GameManager.Names.Ball]?.filteringMode = .nearest
        
        // Create texture atlas
        var images = [String: UIImage]()
        
        for (key, texture) in textures {

            images[key] = UIImage(cgImage: texture.cgImage())
            
        }
        
        self.atlas = SKTextureAtlas(dictionary: images)
        
    }
    
    func playSound(_ named: String) {
        
        self.view.scene!.run(SKAction.playSoundFileNamed(named, waitForCompletion: false))
        
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
