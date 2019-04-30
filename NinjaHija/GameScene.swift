//
//  GameScene.swift
//  NinjaHija
//
//  Created by PHILOMENA WALLIN on 4/8/19.
//  Copyright © 2019 clc.wallin. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory{
    
    static let monster: UInt32 = 0b1 //number 1
    static let projectile: UInt32 = 0b10 //number 2
    static let all: UInt32 = UInt32.max //max number
    static let none: UInt32 = 0b0 //number 0
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let player = SKSpriteNode(imageNamed: "ninja")
   
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        backgroundColor = UIColor.white
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border
        
        let backgroundMusic = SKAudioNode(fileNamed: "gameMusic.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        createPlayer()
        
     //   for i in 0...6{
     //   createMonster()
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(createMonster), SKAction.wait(forDuration: 1.0)])))
        
        
        
}
    
    
    func createPlayer(){
        
        
        player.position = CGPoint(x: 50, y: 200)
        player.scale(to: CGSize(width: 60, height: 60)) //setting ninja's size
        //player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        player.physicsBody?.pinned = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        
        addChild(player)
        
      // player.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 50))
        player.physicsBody?.restitution = 1
        player.physicsBody?.linearDamping = 0
        player.physicsBody?.angularDamping = 0
        player.physicsBody?.friction = 0
    }
    
    func createMonster(){
        
       
        let monster = SKSpriteNode(imageNamed: "enemy")
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        //monster.position = randomPoint()
        //monster.position = CGPoint(x: self.size.width, y: 200)
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        monster.scale(to: CGSize(width: 35, height: 35))
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        //monster.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 50))
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.restitution = 1
        monster.physicsBody?.linearDamping = 0
        monster.physicsBody?.angularDamping = 0
        monster.physicsBody?.friction = 0
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
        //monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        monster.physicsBody?.mass = 1
        monster.zPosition = 4
       
        addChild(monster)
        
       
       // monster.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 0))
        let actualDuration = CGFloat.random(in: 2.0...4.0) //creating a random time
        //create the actions
        
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        
       
    }
        func random() -> CGFloat {
            return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        }
        func random(min: CGFloat, max: CGFloat) -> CGFloat {
            return random() * (max - min) + min
            
        }
        
    
    
    func randomPoint() -> CGPoint{
        
        let xPos = Int.random(in: 100...Int(self.size.width)) //randomly generating a number between 0 and the screens width
        let yPos = Int.random(in: 0...Int(self.size.height))
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(SKAction.playSoundFileNamed("pew.wav", waitForCompletion: false))
        //1: get the location of where we touched
        guard let touch = touches.first else{
            return
        }
        let touchLocation = touch.location(in: self)
        
        //2: set the location of star
        let projectile = SKSpriteNode(imageNamed: "star")
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.mass = 1
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        addChild(projectile)
        
        //3: get the direction of where to shoot
        let offSet = touchLocation - projectile.position
        let direction = offSet.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        
        //4: create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        let firstBody = contact.bodyA.node as? SKSpriteNode
        let SecondBody = contact.bodyB.node as? SKSpriteNode
        firstBody?.removeFromParent()
        SecondBody?.removeFromParent()
    }
   
    
   
    }
        
    
    

