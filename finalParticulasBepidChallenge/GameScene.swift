//
//  GameScene.swift
//  finalParticulasBepidChallenge
//
//  Created by Luis Eduardo Boiko Ferreira on 30/08/17.
//  Copyright © 2017 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, UIGestureRecognizerDelegate {
    
    var focusedNode:SKSpriteNode?
    let UnfocusScale: CGFloat = 0.7
    let focusScale: CGFloat = 0.85
    
    var lastLocation:CGPoint = CGPoint(x: 1920/2, y: 2080/2)
    var wiggleAmount:CGFloat = 50 // the lower the value, the more wiggle
    
    
    
    
    override func didMove(to view: SKView) {
        let bg = self.childNode(withName: "Background")
//        bg?.alpha = 0.7
        let moveAction = SKAction.moveTo(x: -320, duration: 35.0)
//        bg?.zPosition = 100
        bg.self?.run(moveAction)
        
        let sol = self.childNode(withName: "Sol")
        let moveSol = SKAction.moveTo(x: 1070, duration: 30.0)
        sol?.run(moveSol)
        
        let grass = self.childNode(withName: "Grass")
//        grass?.zPosition = 2
        //        bg?.alpha = 0.7
        let moveAction2 = SKAction.moveTo(x: -404, duration: 75.0)
        grass.self?.run(moveAction2)
        
        
        self.childNode(withName: "HorrorScene")?.xScale = self.UnfocusScale
        self.childNode(withName: "HorrorScene")?.yScale = self.UnfocusScale
        self.childNode(withName: "PeaceScene")?.xScale = self.UnfocusScale
        self.childNode(withName: "PeaceScene")?.yScale = self.UnfocusScale
        
        self.childNode(withName: "EmptyButtonOne")?.position = (self.childNode(withName: "PeaceScene")?.position)!
        self.childNode(withName: "EmptyButtonTwo")?.position = (self.childNode(withName: "HorrorScene")?.position)!
        
        let tapGestureSelect = UITapGestureRecognizer.init(target: self, action: #selector(tapSelect(_:)))
        tapGestureSelect.allowedPressTypes.append(NSNumber.init(value: UIPressType.select.rawValue))
        tapGestureSelect.delegate = self
        self.view?.addGestureRecognizer(tapGestureSelect)

    }
    
    
    func tapSelect(_ sender: UITapGestureRecognizer) {
        if self.childNode(withName: "HorrorScene")!.frame.size.width > self.childNode(withName: "PeaceScene")!.frame.size.width {
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            let gameScene = SKScene(fileNamed: "HorrorScene.sks")!;
            self.view?.presentScene(gameScene, transition: transition) 
        } else {
            self.view?.presentScene(SKScene(fileNamed: "HappyScene.sks")!, transition: SKTransition.flipVertical(withDuration: 0.5))
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            let location = t.location(in: self)
            
            checkTouch(location: location)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            let location = t.location(in: self)
            
            checkTouch(location: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if (self.focusedNode != nil) {
            self.childNode(withName: "LightBottom")!.position = CGPoint(x: (focusedNode?.position.x)!, y: (focusedNode?.position.y)! - 100)
        }
    }
    
    
    func checkTouch(location: CGPoint) {
        
        let xDiff = (self.lastLocation.x - location.x) / wiggleAmount
        let yDiff = (self.lastLocation.y - location.y) / wiggleAmount
        
        self.lastLocation = location
        
        self.enumerateChildNodes(withName: "//*") {node, stop in
            if node.name != "Background" && node.name != "Logo"{
                if let sprite : SKSpriteNode = node as? SKSpriteNode {
                    if (sprite.frame.contains(location)) {
                        
                        if (sprite.hasActions() == true) {
                            sprite.removeAllActions()
                        }
                        
                        sprite.xScale = self.focusScale
                        sprite.yScale = self.focusScale
                        
                        let difX:CGFloat = sprite.position.x - xDiff
                        let difY:CGFloat = sprite.position.y - yDiff
                        
                        sprite.position = CGPoint(x: difX, y: difY)
                        sprite.zPosition = 100
                        self.focusedNode = sprite
//                        print(self.focusedNode!.name)
                    } else {
                        if (sprite != self.focusedNode) {
                            // se nao estiver selecionado, volte a escala normal
                            sprite.zPosition = 1
                            
                            let scaleAction:SKAction = SKAction.scale(to: self.UnfocusScale, duration: 0.5)
                            scaleAction.timingMode = .easeOut
                            sprite.run(scaleAction)
                            
                            var placeholder:CGPoint = CGPoint(x: 0, y: 0)
                            
                            if (sprite.name == "PeaceScene") {
                                placeholder = self.childNode(withName: "EmptyButtonOne")!.position
                            } else if (sprite.name == "HorrorScene") {
                                placeholder = self.childNode(withName: "EmptyButtonTwo")!.position
                            }
                            
                            if (placeholder != CGPoint(x: 0, y: 0)) {
                                let moveAction:SKAction = SKAction.move(to: placeholder, duration: 0.5)
                                moveAction.timingMode = .easeOut
                                sprite.run(moveAction)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
