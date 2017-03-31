//
//  GameScene.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/6/16.
//  Copyright (c) 2016 Jacob Davis. All rights reserved.
//

import SpriteKit
import GameplayKit
import RetroTextureKit

enum GameState {
    case mainMenu,inGame,gameOver
}

class GameScene: SKScene {
    
    fileprivate var lastUpdateTime: TimeInterval = 0
    
    var playerNode: SKSpriteNode!
    var brickNodes: [BrickNode]!
    var ballNode: BallNode!
    
    var leftWallNode: SKSpriteNode!
    var rightWallNode: SKSpriteNode!
    var topWallNode: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    
    var gameState = GameState.inGame
    
    override func didMove(to view: SKView) {
        
        GameManager.sharedInstance.initialize(view)
        
        self.backgroundColor = UIColor.black
        
//        let pa = [
//        
//            [1, 1, 1, 1],
//            [0, 1, 1, 0],
//            [0, 1, 1, 0],
//            [1, 1, 1, 1]
//        ]
//        
//        let blah = [
//
//            "t": RetroTextureData(retroPixelArray: [
//                
//                [1, 1, 1, 1],
//                [0, 1, 1, 0],
//                [0, 1, 1, 0],
//                [0, 1, 1, 0]
//                
//                ], retroPixelSize: 8),
//
//            "square": RetroTextureData(retroPixelArray: [
//
//                [1, 1, 1, 1],
//                [1, 1, 1, 1],
//                [1, 1, 1, 1],
//                [1, 1, 1, 1]
//                        
//                ], retroPixelSize: 8),
//            
//            "tri": RetroTextureData(retroPixelArray: [
//                
//                [1, 1, 1, 1, 1],
//                [0, 1, 1, 1, 0],
//                [0, 0, 1, 0, 0]
//                
//            ], retroPixelSize: 8)
//            
//        ]
        
        //let tex = RetroTexture.createTextureAtlas(blah, view: view)
        //let s = tex?.size()
        
//        let sprite = SKSpriteNode(texture: tex?.textureNamed("tri"))
//        sprite.color = UIColor.red
//        sprite.colorBlendFactor = 1
//        sprite.position = view.center
//        addChild(sprite)
        
        // Create playing field
        createPlayingField()
        
        // Create bricks
        createPlaceBricks()
        
        // Create player
        let playerTexture = GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Player)
        self.playerNode = SKSpriteNode(texture: playerTexture)
        self.playerNode.color = GameManager.Color.Red
        self.playerNode.colorBlendFactor = 1
        self.playerNode.setScale(1 / UIScreen.main.scale)
        self.playerNode.position = CGPoint(x: view.center.x, y: (self.leftWallNode.position.y - self.leftWallNode.size.height) + (self.playerNode.size.height / 2))
        self.playerNode.zPosition = GameManager.ZOrders.Player
        addChild(self.playerNode)
        
        // Create ball
        let ballTexture = GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Ball)
        let ballWidth = ballTexture.size().width / UIScreen.main.scale
        let ballSize = CGSize(width: ballWidth, height: ballWidth)
        self.ballNode = BallNode(texture: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Ball), color: GameManager.Color.Yellow, size: ballSize)
        self.ballNode.colorBlendFactor = 1
        self.ballNode.position = view.center
        self.ballNode.position.y += 35
        self.ballNode.setScale(1 / UIScreen.main.scale)
        self.ballNode.move = vector2(0, -1)
        self.ballNode.actualMoveSpeed = self.ballNode.moveSpeed
        self.ballNode.zPosition = GameManager.ZOrders.Ball
        addChild(self.ballNode)
        
        // score label
        self.scoreLabel = SKLabelNode(fontNamed: "PhaserBank")
        self.scoreLabel.fontSize = 10
        self.scoreLabel.fontColor = GameManager.Color.LightGray
        self.scoreLabel.text = "0"
        self.scoreLabel.horizontalAlignmentMode = .left
        self.scoreLabel.verticalAlignmentMode = .center
        self.scoreLabel.position = CGPoint(x: 12, y: self.view!.frame.height - (self.view!.frame.height - self.topWallNode.position.y) / 2)
        addChild(self.scoreLabel)
        
        self.scoreLabel.adjustLabelFontSizeToFitHeight(self.view!.frame.height - self.topWallNode.position.y)
        
        // lives label
        self.livesLabel = SKLabelNode(fontNamed: "PhaserBank")
        self.livesLabel.fontSize = 10
        self.livesLabel.fontColor = GameManager.Color.LightGray
        self.livesLabel.text = "3"
        self.livesLabel.horizontalAlignmentMode = .right
        self.livesLabel.verticalAlignmentMode = .center
        self.livesLabel.position = CGPoint(x: self.view!.frame.width - 12, y: self.view!.frame.height - (self.view!.frame.height - self.topWallNode.position.y) / 2)
        addChild(self.livesLabel)
        
        self.livesLabel.adjustLabelFontSizeToFitHeight(self.view!.frame.height - self.topWallNode.position.y)
        
        // start game
        resetBallAndStart()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let previousLocation = touch.previousLocation(in: self)
            let currentLocation = touch.location(in: self)
            
            self.playerNode.position.x += currentLocation.x - previousLocation.x
            
            // Constrain left side
            if (self.playerNode.position.x - self.playerNode.size.width / 2) <= self.leftWallNode.size.width {
                
               self.playerNode.position.x = self.leftWallNode.size.width + (self.playerNode.size.width / 2)
                
            }
            
            // Constrain right side
            if (self.playerNode.position.x + self.playerNode.size.width / 2) >= (self.view!.frame.width - self.leftWallNode.size.width) {
                
                self.playerNode.position.x = (self.view!.frame.width - self.leftWallNode.size.width) - (self.playerNode.size.width / 2)
                
            }
            
        }
        
    }
    
    /////////////////////////////////////////////////////////
    //
    // MARK: GAME LOOP
    //

    override func update(_ currentTime: TimeInterval) {

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        if !isPaused {
            
            switch self.gameState {
            case .mainMenu:
                
                
                break
                
            case .inGame:
                
                if self.ballNode.enabled {
                    
                    // check player hit
                    if self.ballNode.intersects(self.playerNode) {
                        
                        self.ballNode.move.y *= -1
                        
                        // check side
                        let normal = (abs(self.ballNode.position.x - self.playerNode.position.x) - 0) / (self.playerNode.size.width / 2 - 0);
                        self.ballNode.move.x = Float(normal)
                        
                        if self.ballNode.position.x < self.playerNode.position.x {
                            
                            if self.ballNode.move.x > 0 {
                                
                                self.ballNode.move.x *= -1
                                
                            } else {
                                
                                self.ballNode.move.x *= 1
                            }
                            
                        } else {
                            
                            if self.ballNode.move.x > 0 {
                                
                                self.ballNode.move.x *= 1
                                
                            } else {
                                
                                self.ballNode.move.x *= -1
                            }
                            
                        }
                        
                        GameManager.sharedInstance.playSound("bounce_1")
                        
                    }
                    
                    // check brick hit
                    self.enumerateChildNodes(withName: GameManager.Names.Brick, using: {
                        
                        node, stop in
                        
                        if self.ballNode.intersects(node) {
                            
                            let brick = node as! BrickNode
                            
                            let brickIndex = self.brickNodes.index(of: brick)
                            
                            if let brickIndex = brickIndex {
                                
                                GameManager.sharedInstance.score! += brick.brickData.points
                                self.scoreLabel.text = String(GameManager.sharedInstance.score)
                                
                                GameManager.sharedInstance.playSound(brick.brickData.soundName)
                                
                                self.ballNode.actualMoveSpeed = self.ballNode.moveSpeed * brick.brickData.ballSpeedModifier
                                
                                self.brickNodes.remove(at: brickIndex)
                                node.removeFromParent()
                                
                                //brick.physicsBody = SKPhysicsBody(texture: brick.texture!, size: brick.size)
                                //brick.physicsBody?.dynamic = true
                                
                            }
                            
                            self.ballNode.move.y *= -1
                            self.ballNode.move.x *= 1
                            
                            stop.pointee = true
                        }
                        
                    })
                    
                    // check walls
                    if self.leftWallNode.intersects(self.ballNode) || self.rightWallNode.intersects(self.ballNode) {
                        
                        self.ballNode.move.x *= -1
                        GameManager.sharedInstance.playSound("bounce_2")
                        
                    }
                    
                    if self.topWallNode.intersects(self.ballNode) {
                        
                        self.ballNode.move.y *= -1
                        GameManager.sharedInstance.playSound("bounce_2")
                        
                    }
                    
                    if self.ballNode.position.x <= 0 || self.ballNode.position.x >= self.view!.frame.width {
                        
                        self.ballNode.move.x *= -1
                        GameManager.sharedInstance.playSound("bounce_2")
                    }
                    
                    if self.ballNode.position.y >= self.view!.frame.height {
                        
                        self.ballNode.move.y *= -1
                        GameManager.sharedInstance.playSound("bounce_2")
                        
                    }
                    
                    if self.ballNode.position.y <= 0 && self.ballNode.enabled {
                        
                        // remove life
                        GameManager.sharedInstance.lives! -= 1
                        
                        if GameManager.sharedInstance.lives <= 0 {
                            
                            // reset game
                            resetGame()
                            
                        } else {
                            
                            // reset ball
                            resetBallAndStart()
                        }
                        
                        self.livesLabel.text = String(GameManager.sharedInstance.lives)
                        
                    }
                    
                    if self.brickNodes.count == 0 {
                        
                        // reset game
                        resetGame()
                        
                    }
                    
                    // move ball
                    self.ballNode.position.x += CGFloat(self.ballNode.move.x * Float(dt)) * self.ballNode.actualMoveSpeed
                    self.ballNode.position.y += CGFloat(self.ballNode.move.y * Float(dt)) * self.ballNode.actualMoveSpeed
                    
                    // ball trail
                    let trailSprite = self.ballNode.copy() as! SKSpriteNode
                    trailSprite.blendMode = .add
                    addChild(trailSprite)

                    let trailScale = SKAction.scale(to: 0, duration: 0.15)
                    trailSprite.run(trailScale, completion: {
                        
                        trailSprite.removeFromParent()
                    })
                    
                }
                
                break
                
            case .gameOver:
                
                
                break
                
            }
            
            
        }
        
        self.lastUpdateTime = currentTime
        
    }
    
    /////////////////////////////////////////////////////////
    //
    // MARK: SETUP FUNCTIONS
    //
    
    func resetBallAndStart() {
        
        self.ballNode.enabled = false
        self.ballNode.position = self.view!.center
        self.ballNode.position.y += 35
        
        let wait = SKAction.wait(forDuration: 2)
        self.run(wait, completion: { 

            self.ballNode.enabled = true
            self.ballNode.move = vector2(0, -1)
            
        }) 
        
    }
    
    func resetGame() {
        
        GameManager.sharedInstance.score = 0
        GameManager.sharedInstance.lives = 3
        
        self.scoreLabel.text = String(GameManager.sharedInstance.score)
        self.livesLabel.text = String(GameManager.sharedInstance.lives)
        
        createPlaceBricks()
        
        resetBallAndStart()
        
    }
    
    func createPlayingField() {
        
        let brickHeight = GameManager.sharedInstance.brickSize.height
        
        let y:CGFloat = self.view!.frame.height - brickHeight * GameManager.PlayField.BrickRows / 2
        
        self.leftWallNode = SKSpriteNode(texture: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.SideWall))
        self.leftWallNode.color = GameManager.Color.LightGray
        self.leftWallNode.colorBlendFactor = 1
        self.leftWallNode.setScale(1 / UIScreen.main.scale)
        self.leftWallNode.anchorPoint = CGPoint(x: 0, y: 1)
        self.leftWallNode.position = CGPoint(x: 0, y: y)
        self.leftWallNode.zPosition = GameManager.ZOrders.Wall
        addChild(self.leftWallNode)
        
        self.rightWallNode = SKSpriteNode(texture: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.SideWall))
        self.rightWallNode.color = GameManager.Color.LightGray
        self.rightWallNode.colorBlendFactor = 1
        self.rightWallNode.setScale(1 / UIScreen.main.scale)
        self.rightWallNode.anchorPoint = CGPoint(x: 1, y: 1)
        self.rightWallNode.position = CGPoint(x: self.view!.frame.width, y: y)
        self.rightWallNode.zPosition = GameManager.ZOrders.Wall
        addChild(self.rightWallNode)
        
        self.topWallNode = SKSpriteNode(texture: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.TopWall))
        self.topWallNode.color = GameManager.Color.LightGray
        self.topWallNode.colorBlendFactor = 1
        self.topWallNode.setScale(1 / UIScreen.main.scale)
        self.topWallNode.anchorPoint = CGPoint(x: 0, y: 1)
        self.topWallNode.position = CGPoint(x: 0, y: y)
        self.topWallNode.zPosition = GameManager.ZOrders.Wall
        addChild(self.topWallNode)
        
    }
    
    func createPlaceBricks() {
        
        
        // cleanup any brick nodes left
        self.enumerateChildNodes(withName: GameManager.Names.Brick, using: {
            
            node, stop in
            
            node.removeFromParent()
            
        })

        self.brickNodes = [BrickNode]()
        
        // layout brick nodes
        let brickWidth = GameManager.sharedInstance.brickSize.width
        let brickHeight = GameManager.sharedInstance.brickSize.height
        
        var y:CGFloat = (self.topWallNode.position.y - self.topWallNode.size.height) - (brickHeight * GameManager.PlayField.BrickRows / 2)
        
        for i in (1...Int(GameManager.PlayField.BrickRows)).reversed() {
            
            var x:CGFloat = self.view!.center.x - brickWidth * GameManager.PlayField.BrickColumns / 2
            
            for _ in 1...Int(GameManager.PlayField.BrickColumns) {
                
                let brick = BrickNode()
                
                switch i {
                case 1:

                    brick.brickData = BrickData(points: 1, brickRow: .one, color: GameManager.Color.Purple, collectable: false, soundName: "bounce_\(i+2)", ballSpeedModifier: 1)

                    break
                case 2:
                    
                    brick.brickData = BrickData(points: 1, brickRow: .two, color: GameManager.Color.Blue, collectable: false, soundName: "bounce_\(i+2)", ballSpeedModifier: 1)

                    break
                case 3:
                    
                    brick.brickData = BrickData(points: 4, brickRow: .three, color: GameManager.Color.Green, collectable: false, soundName: "bounce_\(i+2)", ballSpeedModifier: 1)
                    
                    break
                case 4:
                    
                    brick.brickData = BrickData(points: 4, brickRow: .four, color: GameManager.Color.Yellow, collectable: false, soundName: "bounce_\(i+2)", ballSpeedModifier: 1.33)
                    
                    break
                case 5:
                    
                    brick.brickData = BrickData(points: 7, brickRow: .five, color: GameManager.Color.Orange, collectable: false, soundName: "bounce_\(i+2)", ballSpeedModifier: 1.66)
                    
                    break
                case 6:
                    
                    brick.brickData = BrickData(points: 7, brickRow: .six, color: GameManager.Color.Red, collectable: false, soundName: "bounce_\(i+2)", ballSpeedModifier: 2)
                    
                    break
                default:
                    ()
                }
                
                brick.position = CGPoint(x: x, y: y)

                self.brickNodes.append(brick)
                
                addChild(brick)
                
                x += brickWidth
                
            }
            
            y -= brickHeight
            
        }
        
    }

}
