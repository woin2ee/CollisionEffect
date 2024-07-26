//
//  AccelerateShakeCollisionEffectViewController.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/25/24.
//

import UIKit

final class AccelerateShakeCollisionEffectViewController: CollisionEffectViewController {

    let shakeManager = ShakeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shakeManager.startDetecting { x, y, _ in
            let amplificationScale: Double = 20
            let variationRange = (-30...30)
            
            self.scene.queue.forEach { shapeNode in
                shapeNode.physicsBody?.velocity = CGVector(
                    dx: -(x * amplificationScale) + Double(variationRange.randomElement()!),
                    dy: -(y * amplificationScale) + Double(variationRange.randomElement()!)
                )
            }
        }
    }
}
