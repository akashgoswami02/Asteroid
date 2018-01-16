//
//  GameScene.swift
//  Climb
//
//  Created by Akash Goswami on 1/28/16.
//  Copyright (c) 2016 Akash Goswami. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    
    static let ship : UInt32 = 0x1 << 1
    static let asteroid : UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ship = SKSpriteNode()
    var score = Int()
    var asteroid = SKSpriteNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool ()
    var isAlive = Bool ()
    
    override func didMove(to view: SKView) {
        
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
         myLabel.text = "Hello, World!"
         myLabel.fontSize = 45
         myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
         
         self.addChild(myLabel)*/
        
        ship = SKSpriteNode (imageNamed: "Ufo")
        
        ship.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
        ship.setScale(0.3)
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.frame.width/2)
        ship.physicsBody?.categoryBitMask = PhysicsCategory.ship
        ship.physicsBody?.collisionBitMask = PhysicsCategory.asteroid
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        
        ship.physicsBody?.isDynamic = true
        
        ship.physicsBody?.affectedByGravity = false
        ship.zPosition = 2
        
        self.addChild(ship)
        
        isAlive = true
        
        /*block.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
         block.physicsBody?.affectedByGravity = false
         block.setScale(0.5)
         self.addChild(block)*/
        
        
        
    }
    
    func createAsteroids() {
        
        //block = SKNode()
        
        /*let leftBlock = SKSpriteNode(imageNamed: "Block")
        let rightBlock = SKSpriteNode(imageNamed: "Block")
        
        leftBlock.position = CGPoint(x: self.frame.width/2 + 200, y: self.frame.height)
        rightBlock.position = CGPoint(x: self.frame.width/2 - 200, y: self.frame.height)
        
        leftBlock.setScale(0.5)
        rightBlock.setScale(0.5)
        
        leftBlock.physicsBody = SKPhysicsBody(rectangleOfSize: leftBlock.size)
        leftBlock.physicsBody?.categoryBitMask = PhysicsCategory.block
        leftBlock.physicsBody?.collisionBitMask = PhysicsCategory.ship
        leftBlock.physicsBody?.contactTestBitMask = PhysicsCategory.ship
        leftBlock.physicsBody?.dynamic = false
        leftBlock.physicsBody?.affectedByGravity = false
        
        rightBlock.physicsBody = SKPhysicsBody(rectangleOfSize: rightBlock.size)
        rightBlock.physicsBody?.categoryBitMask = PhysicsCategory.block
        rightBlock.physicsBody?.collisionBitMask = PhysicsCategory.ship
        rightBlock.physicsBody?.contactTestBitMask = PhysicsCategory.ship
        rightBlock.physicsBody?.dynamic = false
        rightBlock.physicsBody?.affectedByGravity = false
        
        //block.physicsBody?.dynamic = false
        //block.physicsBody?.affectedByGravity = false
        
        block.addChild(leftBlock)
        block.addChild(rightBlock)
        */
        asteroid = SKSpriteNode(imageNamed: "Asteroid")
        
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.frame.width/2)
        asteroid.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        asteroid.physicsBody?.collisionBitMask = PhysicsCategory.ship
        asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.ship
        
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.isDynamic = false
        
        asteroid.zPosition = 1
        asteroid.setScale(0.3)
        
        let randomPosition = CGFloat.random(min: 0, max: self.frame.width)
        asteroid.position.x = randomPosition
        asteroid.position.y = self.frame.height + (asteroid.frame.height/2)
        
        //block.position.x = 30
        
        let rotate = SKAction.rotate(byAngle: CGFloat(-M_PI), duration: 1)
        asteroid.run(SKAction.repeatForever(rotate))
        asteroid.run(moveAndRemove)
        
        self.addChild(asteroid)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            
            gameStarted = true
            
            let spawn = SKAction.run({
                () in
                
                self.createAsteroids()
            })
            
            let delay = SKAction.wait(forDuration: 1.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.height + asteroid.frame.height + asteroid.frame.height)
            let moveBlocks = SKAction.moveBy(x: 0, y: -distance - asteroid.frame.height, duration: TimeInterval (0.009*distance))
            let removeBlocks = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveBlocks, removeBlocks])
            
            /*for touch in touches {
             
             let location = touch.locationInNode(self)
             
             ship.position.x = location.x
             
             //let sprite = SKSpriteNode(imageNamed:"Spaceship")
             
             // sprite.xScale = 0.5
             // sprite.yScale = 0.5
             // sprite.position = location
             
             //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
             
             //sprite.runAction(SKAction.repeatActionForever(action))
             
             //self.addChild(sprite)
             }*/
        }
        else {
            
            for touch in touches {
                
                let location = touch.location(in: self)
                
                let half = ship.frame.width/2
                
                let leftLimit = ship.position.x - half
                let rightLimit = ship.position.x + half
                
                if location.x >= leftLimit && location.x <= rightLimit {
                    ship.position.x = location.x
                }
                /*ship.physicsBody?.velocity = CGVectorMake(0, 0)
                
                if location.x > self.frame.width / 2 {
                    ship.physicsBody?.applyImpulse(CGVectorMake(10, 0))
                }
                else {
                    ship.physicsBody?.applyImpulse(CGVectorMake(-10, 0))
                }*/
            }
            
            
            /*for touch in touches {
             
             let location = touch.locationInNode(self)
             
             ship.position.x = location.x
             
             //let sprite = SKSpriteNode(imageNamed:"Spaceship")
             
             // sprite.xScale = 0.5
             // sprite.yScale = 0.5
             // sprite.position = location
             
             //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
             
             //sprite.runAction(SKAction.repeatActionForever(action))
             
             //self.addChild(sprite)
             }*/
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            let half = ship.frame.width/2
            
            let leftLimit = ship.position.x - half
            let rightLimit = ship.position.x + half
            
            if location.x >= leftLimit && location.x <= rightLimit {
                ship.position.x = location.x
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == PhysicsCategory.ship && bodyB.categoryBitMask == PhysicsCategory.asteroid || bodyA.categoryBitMask == PhysicsCategory.asteroid && bodyB.categoryBitMask == PhysicsCategory.ship {
            
            
        }
        
        ship.speed = 0;
        self.removeAllActions()
    }
    
    /*override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
     
     for touch in touches {
     
     let location = touch.locationInNode(self)
     
     ship.position.x = location.x
     }
     }*/
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
