//
//  CircleScene.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/16/24.
//

import SpriteKit

final class CircleScene: SKScene {

    let circleNode: SKShapeNode
    
    override init() {
        circleNode = SKShapeNode(circleOfRadius: 20)
        circleNode.name = "circle_node"
        circleNode.lineWidth = 2
        circleNode.fillColor = .blue
        circleNode.strokeColor = .white
        circleNode.glowWidth = 0
        circleNode.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        
        super.init(size: .zero)
        
        scaleMode = .resizeFill
        backgroundColor = .brown
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        createCircle(at: .zero)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.count)
        touches.forEach { touch in
            createCircle(at: touch.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func createCircle(at point: CGPoint) {
        let node = circleNode.copy() as! SKShapeNode
        node.position = point
        addChild(node)
    }
}
