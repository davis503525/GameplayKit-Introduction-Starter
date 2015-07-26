//
//  GameViewController.swift
//  GameplayKit Introduction
//
//  Created by Davis Allie on 19/07/2015.
//  Copyright (c) 2015 Davis Allie. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var mainScene: GameScene!

    @IBOutlet weak var scoreLabel: UILabel!
    var score = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
            mainScene = scene
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScore:", name: "updateScore", object: nil)
    }

    func updateScore(notification: NSNotification) {
        let scoreToAdd = notification.userInfo?["score"] as! Int
        self.score += scoreToAdd
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: Button Movements
    @IBAction func beginMovement(sender: UIButton) {
        switch sender.tag {
        case 1:
            self.mainScene.startMoveUp()
        case 2:
            self.mainScene.startMoveRight()
        case 3:
            self.mainScene.startMoveDown()
        case 4:
            self.mainScene.startMoveLeft()
        default:
            break
        }
    }
    
    @IBAction func endMovement(sender: UIButton) {
        switch sender.tag {
        case 1:
            self.mainScene.endMoveUp()
        case 2:
            self.mainScene.endMoveRight()
        case 3:
            self.mainScene.endMoveDown()
        case 4:
            self.mainScene.endMoveLeft()
        default:
            break
        }
    }
    
}
