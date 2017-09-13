//
//  AdjustsMenu.swift
//  finalParticulasBepidChallenge
//
//  Created by Eldade Marcelino on 12/09/17.
//  Copyright © 2017 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation
import SpriteKit

class AdjustsMenu {
    
    var MainFrame: SKShapeNode!
    var containerScene: SKScene!
    
    class Settings {
        
        var birthRate: Float!
        var density: Float!
        var currentSongNumber: Int8!
        var sparkling: Bool!
        var clubEffect: Bool!
    }
    
    init(container: SKScene) {
        
        self.containerScene = container
        self.MainFrame = SKShapeNode(rectOf: CGSize(width: 600, height: 1080))
        self.MainFrame.position = CGPoint(x: self.containerScene.frame.width * 0.5, y: 0)
        self.MainFrame.fillColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.15)
        self.MainFrame.lineWidth = 0
        self.containerScene.addChild(self.MainFrame)
        self.MainFrame.run(SKAction.moveBy(x: self.MainFrame.frame.width * -0.5, y: 0, duration: 0.3))
        
        self.MainFrame.addChild(SKLabelNode(text: "Menu"))
    }
}
