//
//  GameScene.swift
//  GameplayKit Introduction
//
//  Created by Davis Allie on 19/07/2015.
//  Copyright (c) 2015 Davis Allie. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let worldNode = SKNode()
    let cameraNode = SKCameraNode()
    
    let playerNode = PlayerNode(circleOfRadius: 50)
    
    var upDisplayTimer: Timer!
    var rightDisplayTimer: Timer!
    var downDisplayTimer: Timer!
    var leftDisplayTimer: Timer!
    
    var respawnTimer: Timer!
    
    let spawnPoints = [
        CGPoint(x: 245, y: 3900),
        CGPoint(x: 700, y: 3500),
        CGPoint(x: 1250, y: 1500),
        CGPoint(x: 1200, y: 1950),
        CGPoint(x: 1200, y: 2450),
        CGPoint(x: 1200, y: 2950),
        CGPoint(x: 1200, y: 3400),
        CGPoint(x: 2550, y: 2350),
        CGPoint(x: 2500, y: 3100),
        CGPoint(x: 3000, y: 2400),
    ]
    
    override func didMove(to view: SKView) {
        /* Scene setup */
        self.addChild(worldNode)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self

        let moveUpSelector = #selector(moveUp)
        self.upDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: moveUpSelector, userInfo: nil, repeats: true)
        let moveRightSelector = #selector(moveRight)
        self.rightDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: moveRightSelector, userInfo: nil, repeats: true)
        let moveDownSelector = #selector(moveDown)
        self.downDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: moveDownSelector, userInfo: nil, repeats: true)
        let moveLeftSelector = #selector(moveLeft)
        self.leftDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: moveLeftSelector, userInfo: nil, repeats: true)

        let respawnSelector = #selector(respawn)
        self.respawnTimer = Timer(timeInterval: 1.0, target: self, selector: respawnSelector, userInfo: nil, repeats: true)
        RunLoop.main.add(self.respawnTimer, forMode: RunLoopMode.commonModes)
        
        self.camera = cameraNode
        self.camera?.position = CGPoint(x: 2048, y: 2048)
        self.camera?.setScale(1.0)
        
        playerNode.position = CGPoint(x: 2048, y: 2048)
        playerNode.fillColor = UIColor.blue
        playerNode.lineWidth = 0.0
        
        let playerBody = SKPhysicsBody(circleOfRadius: 50)
        playerBody.contactTestBitMask = 1
        playerNode.physicsBody = playerBody
        
        self.addChild(playerNode)
        self.initialSpawn()
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.camera?.position = playerNode.position
    }
    
    //  MARK: - Physics Delegate

    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        if let contact = nodeA as? ContactNode, nodeB! is PlayerNode {
            self.handleContactWithNode(contact: contact)
        }
        else if let contact = nodeB as? ContactNode, nodeA! is PlayerNode {
            self.handleContactWithNode(contact: contact)
        }
    }
    
    func handleContactWithNode(contact: ContactNode) {
        if contact is PointsNode {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateScore"), object: self, userInfo: ["Score": 1])
        }
        else if contact is RedEnemyNode {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateScore"), object: self, userInfo: ["score": -2])
        }
        else if contact is YellowEnemyNode {
            self.playerNode.enabled = false
        }
        
        contact.removeFromParent()
    }
    
    //  MARK: - Respawning Behaviour
    func initialSpawn() {
        for point in self.spawnPoints {
            let respawnFactor = arc4random() % 3  //  Will produce a value between 0 and 2 (inclusive)
            
            let node: SKShapeNode

            switch respawnFactor {
            case 0:
                node = PointsNode(circleOfRadius: 25)
                node.physicsBody = SKPhysicsBody(circleOfRadius: 25)
                node.fillColor = UIColor.green
            case 1:
                node = RedEnemyNode(circleOfRadius: 75)
                node.physicsBody = SKPhysicsBody(circleOfRadius: 75)
                node.fillColor = UIColor.red
            case 2:
                node = YellowEnemyNode(circleOfRadius: 50)
                node.physicsBody = SKPhysicsBody(circleOfRadius: 50)
                node.fillColor = UIColor.yellow
            default:
                node = SKShapeNode()
                break
            }

            if (node.self === SKShapeNode.self) != true {
                node.position = point
                node.strokeColor = UIColor.clear
                node.physicsBody!.contactTestBitMask = 1
                self.addChild(node)
            }
        }
    }
    
    @objc func respawn() {
        
    }
    
    //  MARK: - Movement Methods
    func startMoveUp() {
        RunLoop.main.add(self.upDisplayTimer, forMode: RunLoopMode.commonModes)
    }
    
    func endMoveUp() {
        self.upDisplayTimer.invalidate()
        let selector = #selector(moveUp)
        self.upDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    @objc func moveUp() {
        let action = SKAction.moveBy(x: 0, y: 10, duration: 0.0)
        if self.playerNode.enabled {
            self.playerNode.run(action)
        }
    }
    
    func startMoveRight() {
        RunLoop.main.add(self.rightDisplayTimer, forMode: RunLoopMode.commonModes)
    }
    
    func endMoveRight() {
        self.rightDisplayTimer.invalidate()
        let selector = #selector(moveRight)
        self.rightDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    @objc func moveRight() {
        let action = SKAction.moveBy(x: 10, y: 0, duration: 0.0)
        if self.playerNode.enabled {
            self.playerNode.run(action)
        }
    }
    
    func startMoveDown() {
        RunLoop.main.add(self.downDisplayTimer, forMode: RunLoopMode.commonModes)
    }
    
    func endMoveDown() {
        self.downDisplayTimer.invalidate()
        let selector = #selector(moveDown)
        self.downDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    @objc func moveDown() {
        let action = SKAction.moveBy(x: 0, y: -10, duration: 1.0/60.0)
        if self.playerNode.enabled {
            self.playerNode.run(action)
        }
    }
    
    func startMoveLeft() {
        RunLoop.main.add(self.leftDisplayTimer, forMode: RunLoopMode.commonModes)
    }
    
    func endMoveLeft() {
        self.leftDisplayTimer.invalidate()
        let selector = #selector(moveLeft)
        self.leftDisplayTimer = Timer(timeInterval: 1.0/60.0, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    @objc func moveLeft() {
        let action = SKAction.moveBy(x: -10, y: 0, duration: 1.0/60.0)
        if self.playerNode.enabled {
            self.playerNode.run(action)
        }
    }
}
