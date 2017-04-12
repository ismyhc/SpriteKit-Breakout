//
//  GameViewController.swift
//  Sprite Kit Breakout
//
//  Created by Jacob Davis on 7/6/16.
//  Copyright (c) 2016 Jacob Davis. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let scene = GameScene()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsDrawCount = true

        scene.scaleMode = .resizeFill
        
        skView.presentScene(scene)
        
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
