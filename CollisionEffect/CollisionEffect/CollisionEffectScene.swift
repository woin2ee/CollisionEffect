//
//  CollisionEffectScene.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/16/24.
//

import FIFOQueue
import SpriteKit

enum CircleVelocity: Int {
    case normal = 50
    case fast = 70
    
    var range: ClosedRange<Int> {
        (-self.rawValue...self.rawValue)
    }
}

final class CollisionEffectScene: SKScene {

    let backgroundGradientNode: SKSpriteNode
    private let circleNode: SKShapeNode
    
    let queue: FIFOQueue = FIFOQueue<SKShapeNode>(maxCapacity: 7)
    
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
        backgroundGradientNode = SKSpriteNode(texture: texture)
//        gradientNode.run(.fadeOut(withDuration: 2.0))
        
        let radius: CGFloat = 50
        circleNode = SKShapeNode(circleOfRadius: radius)
        circleNode.lineWidth = 1
        circleNode.fillColor = .white.withAlphaComponent(0.2)
        circleNode.strokeColor = .white.withAlphaComponent(0.8)
        circleNode.glowWidth = 0
        let circlePhysicsBody = SKPhysicsBody(circleOfRadius: radius)
        circlePhysicsBody.restitution = 1.0
        circlePhysicsBody.linearDamping = 0.0
        circlePhysicsBody.angularDamping = 0.0
        circleNode.physicsBody = circlePhysicsBody
        
        super.init(size: .zero)
        
        addChild(backgroundGradientNode)
        
        scaleMode = .resizeFill
        backgroundColor = .clear
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        let backgroundGradientPhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        backgroundGradientPhysicsBody.friction = 0.0
        physicsBody = backgroundGradientPhysicsBody
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
        let velocityRange = CircleVelocity.normal.range
        node.physicsBody?.velocity = CGVector(dx: velocityRange.randomElement()!, dy: velocityRange.randomElement()!)
        
        addChild(node)
        
        let overNode = queue.enqueue(node)
        overNode?.run(.sequence([
            .fadeOut(withDuration: 0.7),
            .removeFromParent(),
        ]))
    }
}
