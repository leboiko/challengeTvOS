//
//  HappyScene.swift
//  finalParticulasBepidChallenge
//
//  Created by Eldade Marcelino on 31/08/17.
//  Copyright © 2017 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class HappyScene: SKScene {
    
    var fire: SKEmitterNode?
    var rain: SKEmitterNode?
    var rain2: SKEmitterNode?
    var currentTexture = 0
    var textures = [SKShapeNode(circleOfRadius: 10), SKShapeNode(rectOf: CGSize(width: 20, height: 30))]
    fileprivate var dust: Dust1?
    var action: SKAction?
    var avplayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        
        avplayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Lights - Just Happy.mp3", ofType:nil)!))
        avplayer?.play()
        
        fire = SKEmitterNode(fileNamed: "MyParticle.sks")
        fire?.particleTexture = view.texture(from: SKShapeNode(circleOfRadius: 10))
        fire?.particleBirthRate = 1000
        fire?.particleScaleRange = 1
        fire?.emissionAngle = 1
        fire?.targetNode = self
        self.addChild(self.fire!)
        
        rain = SKEmitterNode(fileNamed: "Rain.sks")
        rain?.particleTexture = view.texture(from: SKShapeNode(circleOfRadius: 10))
        rain?.particleBirthRate = 0
        rain?.particleScaleRange = 1
        rain?.targetNode = self
        self.addChild(rain!)
        
        rain2 = SKEmitterNode(fileNamed: "Rain.sks")
        rain2?.particleTexture = view.texture(from: SKShapeNode(circleOfRadius: 10))
        rain2?.particleBirthRate = 0
        rain2?.particleScaleRange = 1
        rain2?.targetNode = self
        self.addChild(rain2!)
        
        //TODO: optimze loadtime
        self.dust = Dust1(numberOfParticles_: 1500, fillIn: self)
        self.dust!.renderIn(node: self)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 24))
        path.addLine(to: CGPoint(x: 40, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        textures.append(SKShapeNode(path: path))
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view?.addGestureRecognizer(tapRec)
        
        let menuRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(menuButton(_:)))
        menuRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        self.view?.addGestureRecognizer(menuRecognizer)
    }
    
    func menuButton(_ tapRecognizer : UITapGestureRecognizer){
        self.view?.presentScene(SKScene(fileNamed: "GameScene.sks")!, transition: SKTransition.flipVertical(withDuration: 0.5))
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        avplayer?.stop()
        if(presses.first?.type == UIPressType.menu) {
            let transition = SKTransition.flipVertical(withDuration: 1.5)
            let gameScene = SKScene(fileNamed: "GameScene.sks")!;
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    @objc func tapHandler() {
        if fire!.particleBirthRate > 0 {
            fire!.particleBirthRate = 0
            rain!.particleBirthRate = 400
            rain2!.particleBirthRate = 400
            dust?.hide()
        } else {
            fire!.particleBirthRate = 1000
            rain!.particleBirthRate = 0
            rain2!.particleBirthRate = 0
            dust?.show()
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        fire?.particleScaleRange = 2.5
        rain?.particleScaleRange = 2.5
        rain2?.particleScaleRange = 2.5
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        dust!.newPosition = pos
        fire?.position = pos
        rain?.position = pos
        rain2?.position = pos
        rain2?.position.x = -1*pos.x
        atualizaCorPArticulas(controle: false)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        fire?.particleScaleRange = 1
        if currentTexture == self.textures.count {
            self.currentTexture = 0
        }
        fire?.particleTexture = self.view?.texture(from: textures[currentTexture])
        rain?.particleTexture = self.view?.texture(from: textures[currentTexture])
        currentTexture = currentTexture + 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func atualizaCorPArticulas (controle: Bool) {
        let colors = [UIColor.green, UIColor.white, UIColor.yellow, UIColor.cyan, UIColor.red, UIColor.orange, UIColor.purple]
        let random = Int(arc4random_uniform(UInt32(colors.count)))
        
        self.fire?.particleColorSequence = nil
        self.fire?.particleColorBlendFactor = 1000.0
        self.fire?.particleColor = colors[random]
        
        self.rain?.particleColorSequence = nil
        self.rain?.particleColorBlendFactor = 1000.0
        self.rain?.particleColor = colors[random]
        
        self.rain2?.particleColorSequence = nil
        self.rain2?.particleColorBlendFactor = 1000.0
        self.rain2?.particleColor = colors[random]
    }
}

private class Dust1 {
    
    var shapeNodes = [SKSpriteNode]()
    var initialPosition = [CGPoint]()
    var gravity: SKFieldNode?
    var isRestoring = false
    var schedulePosChange = false
    var posChanger: () -> Void = {_ in }
    var newPosition = CGPoint(x: 0, y: 0)
    
    init (numberOfParticles_: Int, fillIn: SKNode) {
        
        let numberOfParticles = Int(sqrt(Double(numberOfParticles_)))
        let x0 = fillIn.frame.width / -2
        let y0 = fillIn.frame.height / -2
        
        for i in 0..<numberOfParticles {
            
            for j in 0..<numberOfParticles {
                
                let dx = fillIn.frame.width / CGFloat(numberOfParticles - 1)
                let dy = fillIn.frame.height / CGFloat(numberOfParticles - 1)
                let shape = SKShapeNode(circleOfRadius: 2)
                shape.fillColor = [UIColor.cyan, UIColor.white, UIColor.red][Int(arc4random_uniform(2))]
                shape.lineWidth = 0
                shape.alpha = CGFloat(arc4random_uniform(10)) / 20
                shape.position = CGPoint(x: CGFloat(20 - Int(arc4random_uniform(40))) + x0 + CGFloat(i) * dx, y: CGFloat(20 - Int(arc4random_uniform(40))) + y0 + CGFloat(j) * dy)
                initialPosition.append(CGPoint(x: shape.position.x, y: shape.position.y))
                shapeNodes.append(SKSpriteNode.init(texture: (fillIn as! SKScene).view!.texture(from: shape)))
            }
        }
        
        gravity = SKFieldNode.radialGravityField()
        gravity?.strength = -3
    }
    
    public func restorePositions() {
        
        for i in 0..<shapeNodes.count {
            
            let action_x = SKAction.moveTo(x: initialPosition[i].x, duration: 0.3)
            let action_y = SKAction.moveTo(y: initialPosition[i].y, duration: 0.3)
            action_x.timingFunction = { (t: Float) in
                return powf(t, 2)
            }
            action_y.timingFunction = { (t: Float) in
                return powf(t, 2)
            }
            
            shapeNodes[i].physicsBody = nil
            shapeNodes[i].run(action_x)
            
            if i == self.shapeNodes.count - 1 {
                shapeNodes[i].run(action_y) {
                    self.shapeNodes.forEach({ shape in
                        shape.physicsBody = SKPhysicsBody(circleOfRadius: shape.frame.width * 0.5)
                        shape.physicsBody?.collisionBitMask = 0x00000000
                        shape.physicsBody?.affectedByGravity = false
                        self.gravity?.position = self.newPosition
                    })
                }
            } else {
                shapeNodes[i].run(action_y)
            }
        }
        
        shapeNodes.first?.run(SKAction.applyAngularImpulse(0, duration: 1)) {
            
            self.restorePositions()
        }
    }
    
    public func renderIn (node: SKNode) {
        
        shapeNodes.forEach { particle in
            node.addChild(particle)
        }
        
        node.addChild(gravity!)
        
        node.run(SKAction.applyAngularImpulse(0, duration: 1)) {
            
            self.restorePositions()
        }
    }
    
    public func show() {
        
        shapeNodes.forEach { node in
            node.isHidden = false
        }
    }
    
    public func hide() {
        
        shapeNodes.forEach { node in
            node.isHidden = true
        }
    }
}

