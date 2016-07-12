//
//  GameScene.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/6/16.
//  Copyright (c) 2016 Jacob Davis. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
    case MainMenu,InGame,GameOver
}

class GameScene: SKScene {
    
    private var lastUpdateTime: NSTimeInterval = 0
    
    var playerNode: SKSpriteNode!
    var brickNodes: [BrickNode]!
    var ballNode: BallNode!
    
    var leftWallNode: SKSpriteNode!
    var rightWallNode: SKSpriteNode!
    var topWallNode: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    
    var gameState = GameState.InGame
    
    override func didMoveToView(view: SKView) {
        
        GameManager.sharedInstance.initialize(view)
        
        self.backgroundColor = UIColor.blackColor()
        
        // Create playing field
        createPlayingField()
        
        // Create bricks
        createPlaceBricks()
        
        // Create player
        let playerTexture = GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Player)
        self.playerNode = SKSpriteNode(texture: playerTexture)
        self.playerNode.color = GameManager.Color.Red
        self.playerNode.colorBlendFactor = 1
        self.playerNode.setScale(1 / UIScreen.mainScreen().scale)
        self.playerNode.position = CGPoint(x: view.center.x, y: (self.leftWallNode.position.y - self.leftWallNode.size.height) + (self.playerNode.size.height / 2))
        self.playerNode.zPosition = GameManager.ZOrders.Player
        addChild(self.playerNode)
        
        // Create ball
        let ballTexture = GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Ball)
        let ballWidth = ballTexture.size().width / UIScreen.mainScreen().scale
        let ballSize = CGSize(width: ballWidth, height: ballWidth)
        self.ballNode = BallNode(texture: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.Ball), color: GameManager.Color.Yellow, size: ballSize)
        self.ballNode.colorBlendFactor = 1
        self.ballNode.position = view.center
        self.ballNode.position.y += 35
        self.ballNode.setScale(1 / UIScreen.mainScreen().scale)
        self.ballNode.move = vector2(0, -1)
        self.ballNode.moveSpeed = 250
        self.ballNode.zPosition = GameManager.ZOrders.Ball
        addChild(self.ballNode)
        
        // score label
        self.scoreLabel = SKLabelNode(fontNamed: "PhaserBank")
        self.scoreLabel.fontSize = 10
        self.scoreLabel.fontColor = GameManager.Color.LightGray
        self.scoreLabel.text = "0"
        self.scoreLabel.horizontalAlignmentMode = .Left
        self.scoreLabel.verticalAlignmentMode = .Center
        self.scoreLabel.position = CGPoint(x: 12, y: self.view!.frame.height - (self.view!.frame.height - self.topWallNode.position.y) / 2)
        addChild(self.scoreLabel)
        
        self.scoreLabel.adjustLabelFontSizeToFitHeight(self.view!.frame.height - self.topWallNode.position.y)
        
        // lives label
        self.livesLabel = SKLabelNode(fontNamed: "PhaserBank")
        self.livesLabel.fontSize = 10
        self.livesLabel.fontColor = GameManager.Color.LightGray
        self.livesLabel.text = "3"
        self.livesLabel.horizontalAlignmentMode = .Right
        self.livesLabel.verticalAlignmentMode = .Center
        self.livesLabel.position = CGPoint(x: self.view!.frame.width - 12, y: self.view!.frame.height - (self.view!.frame.height - self.topWallNode.position.y) / 2)
        addChild(self.livesLabel)
        
        self.livesLabel.adjustLabelFontSizeToFitHeight(self.view!.frame.height - self.topWallNode.position.y)
        
        // start game
        resetBallAndStart()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let previousLocation = touch.previousLocationInNode(self)
            let currentLocation = touch.locationInNode(self)
            
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

    override func update(currentTime: NSTimeInterval) {

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        
        switch self.gameState {
        case .MainMenu:
            
            
            break
            
        case .InGame:
            
            if self.ballNode.enabled {
                
                // check player hit
                if self.ballNode.intersectsNode(self.playerNode) {
                    
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
                    
                    let a = SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
                    self.runAction(a)
                    
                }
                
                // check brick hit
                self.enumerateChildNodesWithName(GameManager.Names.Brick, usingBlock: {
                    
                    node, stop in
                    
                    if self.ballNode.intersectsNode(node) {
                        
                        let brick = node as! BrickNode
                        
                        let brickIndex = self.brickNodes.indexOf(brick)
                        
                        if let brickIndex = brickIndex {
                            
                            GameManager.sharedInstance.score! += brick.brickData.points
                            self.scoreLabel.text = String(GameManager.sharedInstance.score)
                            
                            let a = SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
                            self.runAction(a)
                            
                            self.brickNodes.removeAtIndex(brickIndex)
                            node.removeFromParent()
                            
//                            brick.physicsBody = SKPhysicsBody(texture: brick.texture!, size: brick.size)
//                            brick.physicsBody?.dynamic = true                                                                                    
                            
                            
                        }
                        
                        self.ballNode.move.y *= -1
                        self.ballNode.move.x *= 1
                        
                        stop.memory = true
                    }
                    
                })
                
                // check walls
                if self.leftWallNode.intersectsNode(self.ballNode) || self.rightWallNode.intersectsNode(self.ballNode) {
                    
                    self.ballNode.move.x *= -1
                    
                    let a = SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
                    self.runAction(a)
                    
                }
                
                if self.topWallNode.intersectsNode(self.ballNode) {
                    
                    self.ballNode.move.y *= -1
                    
                    let a = SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
                    self.runAction(a)
                    
                }
                
                if self.ballNode.position.x <= 0 || self.ballNode.position.x >= self.view!.frame.width {
                    
                    self.ballNode.move.x *= -1
                    
                    let a = SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
                    self.runAction(a)
                }
                
                if self.ballNode.position.y >= self.view!.frame.height {
                    
                    self.ballNode.move.y *= -1
                    
                    let a = SKAction.playSoundFileNamed("ball_bounce", waitForCompletion: false)
                    self.runAction(a)
                    
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
                self.ballNode.position.x += CGFloat(self.ballNode.move.x * Float(dt)) * self.ballNode.moveSpeed
                self.ballNode.position.y += CGFloat(self.ballNode.move.y * Float(dt)) * self.ballNode.moveSpeed
                
                let trailSprite = self.ballNode.copy() as! SKSpriteNode
                trailSprite.blendMode = .Add
                addChild(trailSprite)
                
                //let trailWait = SKAction.waitForDuration(0.1)
                let trailScale = SKAction.scaleTo(0, duration: 0.15)
                
                //let trailFade = SKAction.fadeAlphaTo(0, duration: 0.25)
                trailSprite.runAction(trailScale, completion: {
                    
                    trailSprite.removeFromParent()
                })
                
            }

            break
        case .GameOver:
            
            
            break
            
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
        
        let wait = SKAction.waitForDuration(2)
        self.runAction(wait) { 

            self.ballNode.enabled = true
            self.ballNode.move = vector2(0, -1)
            
        }
        
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
        self.leftWallNode.setScale(1 / UIScreen.mainScreen().scale)
        self.leftWallNode.anchorPoint = CGPoint(x: 0, y: 1)
        self.leftWallNode.position = CGPoint(x: 0, y: y)
        self.leftWallNode.zPosition = GameManager.ZOrders.Wall
        addChild(self.leftWallNode)
        
        self.rightWallNode = SKSpriteNode(texture: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.SideWall))
        self.rightWallNode.color = GameManager.Color.LightGray
        self.rightWallNode.colorBlendFactor = 1
        self.rightWallNode.setScale(1 / UIScreen.mainScreen().scale)
        self.rightWallNode.anchorPoint = CGPoint(x: 1, y: 1)
        self.rightWallNode.position = CGPoint(x: self.view!.frame.width, y: y)
        self.rightWallNode.zPosition = GameManager.ZOrders.Wall
        addChild(self.rightWallNode)
        
        self.topWallNode = SKSpriteNode(texture: GameManager.sharedInstance.atlas.textureNamed(GameManager.Names.TopWall))
        self.topWallNode.color = GameManager.Color.LightGray
        self.topWallNode.colorBlendFactor = 1
        self.topWallNode.setScale(1 / UIScreen.mainScreen().scale)
        self.topWallNode.anchorPoint = CGPoint(x: 0, y: 1)
        self.topWallNode.position = CGPoint(x: 0, y: y)
        self.topWallNode.zPosition = GameManager.ZOrders.Wall
        addChild(self.topWallNode)
        
    }
    
    func createPlaceBricks() {
        
        
        // cleanup any brick nodes left
        self.enumerateChildNodesWithName(GameManager.Names.Brick, usingBlock: {
            
            node, stop in
            
            node.removeFromParent()
            
        })

        self.brickNodes = [BrickNode]()
        
        // layout brick nodes
        let brickWidth = GameManager.sharedInstance.brickSize.width
        let brickHeight = GameManager.sharedInstance.brickSize.height
        
        var y:CGFloat = (self.topWallNode.position.y - self.topWallNode.size.height) - (brickHeight * GameManager.PlayField.BrickRows / 2)
        
        for i in (1...Int(GameManager.PlayField.BrickRows)).reverse() {
            
            var x:CGFloat = self.view!.center.x - brickWidth * GameManager.PlayField.BrickColumns / 2
            
            for _ in 1...Int(GameManager.PlayField.BrickColumns) {
                
                let brick = BrickNode()
                
                switch i {
                case 1:

                    brick.brickData = BrickData(points: 1, brickRow: .One, color: GameManager.Color.Purple, collectable: false)

                    break
                case 2:
                    
                    brick.brickData = BrickData(points: 1, brickRow: .Two, color: GameManager.Color.Blue, collectable: false)

                    break
                case 3:
                    
                    brick.brickData = BrickData(points: 4, brickRow: .Three, color: GameManager.Color.Green, collectable: false)
                    
                    break
                case 4:
                    
                    brick.brickData = BrickData(points: 4, brickRow: .Four, color: GameManager.Color.Yellow, collectable: false)
                    
                    break
                case 5:
                    
                    brick.brickData = BrickData(points: 7, brickRow: .Five, color: GameManager.Color.Orange, collectable: false)
                    
                    break
                case 6:
                    
                    brick.brickData = BrickData(points: 7, brickRow: .Six, color: GameManager.Color.Red, collectable: false)
                    
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
