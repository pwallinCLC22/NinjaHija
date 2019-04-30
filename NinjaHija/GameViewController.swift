//
//  GameViewController.swift
//  NinjaHija
//
//  Created by PHILOMENA WALLIN on 4/8/19.
//  Copyright © 2019 clc.wallin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        
        
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        
            scene.scaleMode = .resizeFill //dot refers to object you are already in
            skView.presentScene(scene)
        
        }
    





    override var prefersStatusBarHidden: Bool {
        return true
    }
}
