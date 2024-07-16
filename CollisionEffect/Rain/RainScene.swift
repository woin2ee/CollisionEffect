//
//  RainScene.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/12/24.
//

import SpriteKit

final class RainScene: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    override func didApplyConstraints() {
        guard let view else { return }
        scene?.size = view.frame.size
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        backgroundColor = .clear
        scene?.anchorPoint = CGPoint(x: 0.5, y: 1)
        scene?.scaleMode = .aspectFit
        
        if let node = SKEmitterNode(fileNamed: "Rain") {
            scene?.addChild(node)
        }
    }
}

final class RainView: SKView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        presentScene(RainScene())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
