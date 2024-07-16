//
//  CollisionEffectScene.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/16/24.
//

import SpriteKit

final class CollisionEffectScene: SKScene {

    let gradientNode: SKSpriteNode
    private let circleNode: SKShapeNode
    
    private var queue: FIFOQueue = FIFOQueue(maxCapacity: 5)
    
    override init() {
        let color1: CGColor = UIColor(red: 209/255, green: 107/255, blue: 165/255, alpha: 1).cgColor
        let color2: CGColor = UIColor(red: 95/255, green: 251/255, blue: 241/255, alpha: 1).cgColor
        
        let layer = CAGradientLayer()
        layer.colors = [color1, color2]
        layer.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        layer.startPoint = CGPoint(x: 0.4, y: 0)
        layer.endPoint = CGPoint(x: 0.6, y: 1)
        
        let renderer = UIGraphicsImageRenderer(size: layer.bounds.size)
        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        let texture = SKTexture(image: image)
        gradientNode = SKSpriteNode(texture: texture)
//        gradientNode.run(.fadeOut(withDuration: 2.0))
        
        let radius: CGFloat = 50
        circleNode = SKShapeNode(circleOfRadius: radius)
        circleNode.lineWidth = 1
        circleNode.fillColor = .white.withAlphaComponent(0.2)
        circleNode.strokeColor = .white.withAlphaComponent(0.8)
        circleNode.glowWidth = 0
        circleNode.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        
        super.init(size: .zero)
        
        addChild(gradientNode)
        
        scaleMode = .resizeFill
        backgroundColor = .clear
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let point = touch.location(in: self)
            createCircle(at: point)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func createCircle(at point: CGPoint) {
        let node = circleNode.copy() as! SKShapeNode
        node.position = point
        
        addChild(node)
        
        let overNode = queue.enqueue(node)
        overNode?.run(.sequence([
            .fadeOut(withDuration: 0.7),
            .removeFromParent(),
        ]))
    }
}
