//
//  GameScene.swift
//  Shooting Game
//
//  Created by mac_os on 22/09/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var balloonColours = ["pink", "purple", "blue"]
    var gameTimer: Timer?
    var balloons = [SKSpriteNode]()
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var playAgainLabel: SKLabelNode!
    var clockTimer: Timer?
    var gameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timeLeft = 0 {
        didSet {
            timerLabel.text = "Time: \(timeLeft)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: 10, y: 700)
        timerLabel.horizontalAlignmentMode = .left
        addChild(timerLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        startGame()
    }
    
    func startGame() {
        gameOver = false
        score = 0
        timeLeft = 60
        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createBalloon), userInfo: nil, repeats: true)
        
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
    }
    
    @objc func countdown() {
        if timeLeft > 0 {
            timeLeft -= 1
        } else {
            gameOver = true
            gameTimer?.invalidate()
            clockTimer?.invalidate()
            playAgain()
        }
    }
    
    @objc func createBalloon() {
        guard let randomColour = balloonColours.randomElement() else { return }
        let balloon = SKSpriteNode(imageNamed: "balloon-\(randomColour)")
        balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.size)
        
        balloon.position = CGPoint(x: Int.random(in: 200...824), y: 0)
        balloon.physicsBody?.velocity = CGVector(dx: Int.random(in: -100...100), dy: Int.random(in:50...500))
        balloon.physicsBody?.restitution = 0.05
        balloon.name = randomColour
        balloons.append(balloon)
        addChild(balloon)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1400
                || node.position.y < -300 || node.position.y > 800 {
                node.removeFromParent()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if let nodeName = node.name {
                if balloonColours.contains(nodeName) && !gameOver {
                    if let pop = SKEmitterNode(fileNamed: "pop") {
                        pop.position = node.position
                        
                        switch nodeName {
                        case "pink":
                            pop.particleColor = .magenta
                        case "blue":
                            pop.particleColor = .blue
                        default:
                            pop.particleColor = .purple
                        }
                        
                        addChild(pop)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            pop.removeFromParent()
                        }
                    }
                    node.removeFromParent()
                    score += 5
                }
                if nodeName == "playagain" && gameOver {
                    playAgainLabel.text = ""
                    startGame()
                }
                
            }
        }
    }
    
    func playAgain() {
        playAgainLabel = SKLabelNode(text: "Your score is \(score)")
        playAgainLabel.fontColor = .white
        playAgainLabel.fontSize = 36
        playAgainLabel.position = CGPoint(x: 512, y: 400)
        playAgainLabel.horizontalAlignmentMode = .center
        playAgainLabel.verticalAlignmentMode = .center
        playAgainLabel.name = "playagain"
        addChild(playAgainLabel)
    }
    
}
