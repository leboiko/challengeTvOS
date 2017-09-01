//
//  GameScene.swift
//  challengeParticulas
//
//  Created by Luis Eduardo Boiko Ferreira on 21/08/17.
//  Copyright © 2017 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

class HorrorScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate, ReactToMotionEvents {

    
    let bgParticle = SKEmitterNode(fileNamed: "bg1.sks")
    let bgParticle2 = SKEmitterNode(fileNamed: "bg2.sks")
    let particles = SKEmitterNode(fileNamed: "magic2.sks")
    let particles2 = SKEmitterNode(fileNamed: "MyParticle.sks")
    let rateParticulasFinas = 600
    let rateParticulas = 150
    var ouveTroca = false
    var particulasPrincipais = [SKEmitterNode]()
    var particulasSecundarias = [SKEmitterNode()]
    
    
    override func didMove(to view: SKView) {
        
        self.run(SKAction.repeatForever(SKAction.playSoundFileNamed("Lights - Creepy.mp3", waitForCompletion: true)))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
        
        self.backgroundColor = UIColor.black
        self.bgParticle?.targetNode = self
        self.addChild(self.bgParticle!)
        
        self.bgParticle2?.targetNode = self
        self.bgParticle2?.particleBirthRate = 0.0
        self.addChild(self.bgParticle2!)
        
        self.particulasPrincipais.append(self.particles!)
        //        self.particulasPrincipais.append(self.particles4!)
        self.particulasSecundarias.append(self.particles2!)
        //        self.particulasSecundarias.append(self.particles2!)
        //
        
        self.resetParticles(listaParticulas: self.particulasPrincipais)
        self.resetParticles(listaParticulas: self.particulasSecundarias)
        
        self.particles?.particleBirthRate = CGFloat(self.rateParticulasFinas)
        self.particles2?.particleBirthRate = CGFloat(self.rateParticulasFinas)
        
        //        self.editarParticulasPrincipais(listaParticulas: self.particulasPrincipais)
        //        self.editarParticulasSecundarias(listaParticulas: self.particulasSecundarias)
        
        
        //        let bgNode = self.childNode(withName: "backgroundParticle")
        //        let nodeImagemTextura = SKSpriteNode(imageNamed: "text")
        //        nodeImagemTextura.setScale(0.3)
        //        bgNode.particleTexture = self.view?.texture(from: nodeImagemTextura)
        
        
        
        
        let tapGestureSelect = UITapGestureRecognizer.init(target: self, action: #selector(tapSelect(_:)))
        tapGestureSelect.allowedPressTypes.append(NSNumber.init(value: UIPressType.select.rawValue))
        tapGestureSelect.delegate = self
        self.view?.addGestureRecognizer(tapGestureSelect)
    }
    
    func motionUpdate(motion: GCMotion) {
        atualizaCorPArticulas(controle: ouveTroca)
    }
    
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if(presses.first?.type == UIPressType.menu) {
            let transition = SKTransition.flipVertical(withDuration: 1.5)
            let gameScene = SKScene(fileNamed: "GameScene.sks")!;
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    func tapSelect(_ sender: UITapGestureRecognizer) {
        if !self.ouveTroca {
            self.bgParticle?.particleBirthRate = 0
            self.bgParticle2?.particleBirthRate = CGFloat(self.rateParticulas)
        } else {
            self.bgParticle2?.particleBirthRate = 0
            self.bgParticle?.particleBirthRate = CGFloat(self.rateParticulas)
        }
        
        self.ouveTroca = !self.ouveTroca
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.run(SKAction.fadeIn(withDuration: 3.0))
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        for touch in touches {
            self.particles?.position.x = (self.particles?.position.x)! + touch.location(in: self).x - touch.previousLocation(in: self).x
            self.particles?.position.y = (self.particles?.position.y)! + touch.location(in: self).y - touch.previousLocation(in: self).y
            
            self.particles2?.position.x = (self.particles2?.position.x)! + touch.location(in: self).x - touch.previousLocation(in: self).x
            self.particles2?.position.y = (self.particles2?.position.y)! + touch.location(in: self).y - touch.previousLocation(in: self).y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.fadeOut(withDuration: 2.0))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func resetParticles(listaParticulas: [SKEmitterNode]) {
        for particula in listaParticulas {
            particula.position = CGPoint(x: 0, y: 0)
            particula.targetNode = self
            particula.particleBirthRate = 0
            self.addChild(particula)
        }
    }
    
    func editarParticulasPrincipais(listaParticulas: [SKEmitterNode]) {
        let nodeImagemTextura = SKSpriteNode(imageNamed: "text")
        nodeImagemTextura.setScale(0.3)
        for particula in listaParticulas {
            particula.particleTexture = self.view?.texture(from: nodeImagemTextura)
        }
    }
    
    func editarParticulasSecundarias(listaParticulas: [SKEmitterNode]) {
        let forma = SKShapeNode(ellipseOf: CGSize(width: 30, height: 10))
        forma.lineWidth = 10.0
        forma.fillColor = SKColor.red
        for particula in listaParticulas {
            particula.particleTexture = self.view?.texture(from: SKShapeNode(ellipseOf: CGSize(width: 50, height: 10)))
            //            particula.xScale = 0.05
            //            particula.yScale = 0.05
            
        }
    }
    
    
    func atualizaCorPArticulas (controle: Bool) {
        let colors = [#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)]
        let random = Int(arc4random_uniform(UInt32(colors.count)))
        
        self.particles2?.particleColorSequence = nil
        self.particles2?.particleColorBlendFactor = 1000.0
        self.particles2?.particleColor = colors[random]
        
    }
    
}









