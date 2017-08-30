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

    let particles = SKEmitterNode(fileNamed: "MyParticle.sks")
    let particles2 = SKEmitterNode(fileNamed: "fireParticle.sks")
    let particles3 = SKEmitterNode(fileNamed: "smoke2.sks")
    let particles4 = SKEmitterNode(fileNamed: "magic2.sks")
    let rateParticulasFinas = 300
    let rateParticulas = 300
    var ouveTroca = false
    var particulasPrincipais = [SKEmitterNode]()
    
    override func didMove(to view: SKView) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionDelegate = self
        
        self.backgroundColor = UIColor.black
        
        self.particulasPrincipais.append(self.particles!)
        self.particulasPrincipais.append(self.particles2!)
        self.particulasPrincipais.append(self.particles3!)
        self.particulasPrincipais.append(self.particles4!)
        
        resetParticles(listaParticulas: particulasPrincipais)

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
    
    
    func tapSelect(_ sender: UITapGestureRecognizer) {
        
        if !ouveTroca {
            self.particles?.particleBirthRate = 0
            self.particles2?.particleBirthRate = 0
            
            self.particles3?.particleBirthRate = CGFloat(self.rateParticulas)
            self.particles4?.particleBirthRate = CGFloat(self.rateParticulas)
            
            
            self.particles3?.position.x = (self.particles?.position.x)!
            self.particles4?.position.x = (self.particles?.position.x)!
            self.particles3?.position.y = (self.particles?.position.y)!
            self.particles4?.position.y = (self.particles?.position.y)!
            
            ouveTroca = !ouveTroca
        } else {
            
            self.particles3?.particleBirthRate = 0
            self.particles4?.particleBirthRate = 0
            
            self.particles?.particleBirthRate = CGFloat(self.rateParticulasFinas)
            self.particles2?.particleBirthRate = CGFloat(self.rateParticulasFinas)
            
            
            self.particles?.position.x = (self.particles3?.position.x)!
            self.particles2?.position.x = (self.particles3?.position.x)!
            self.particles?.position.y = (self.particles3?.position.y)!
            self.particles2?.position.y = (self.particles3?.position.y)!
            
            ouveTroca = !ouveTroca
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.run(SKAction.fadeIn(withDuration: 3.0))
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        for touch in touches {
            
            if !ouveTroca {
            
            self.particles?.position.x = (self.particles?.position.x)! + touch.location(in: self).x - touch.previousLocation(in: self).x
            self.particles?.position.y = (self.particles?.position.y)! + touch.location(in: self).y - touch.previousLocation(in: self).y
            
            self.particles2?.position.x = (self.particles2?.position.x)! + touch.location(in: self).x - touch.previousLocation(in: self).x
            self.particles2?.position.y = (self.particles2?.position.y)! + touch.location(in: self).y - touch.previousLocation(in: self).y
            
            } else {
                self.particles3?.position.x = (self.particles3?.position.x)! + touch.location(in: self).x - touch.previousLocation(in: self).x
                self.particles3?.position.y = (self.particles3?.position.y)! + touch.location(in: self).y - touch.previousLocation(in: self).y
                
                self.particles4?.position.x = (self.particles4?.position.x)! + touch.location(in: self).x - touch.previousLocation(in: self).x
                self.particles4?.position.y = (self.particles4?.position.y)! + touch.location(in: self).y - touch.previousLocation(in: self).y
            }
            
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
    
    func atualizaCorPArticulas (controle: Bool) {
        let colors = [#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        let random = Int(arc4random_uniform(UInt32(colors.count)))
        
        if !controle {
            self.particles?.particleColorSequence = nil
            self.particles?.particleColorBlendFactor = 1000.0
            self.particles?.particleColor = colors[random]
        } else {
            self.particles4?.particleColorSequence = nil
            self.particles4?.particleColorBlendFactor = 1000.0
            self.particles4?.particleColor = colors[random]
        }
        
    }
    
}




