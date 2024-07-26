//
//  RegularShakeCollisionEffectViewController.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/25/24.
//

import UIKit

final class RegularShakeCollisionEffectViewController: CollisionEffectViewController {
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let impactFeedbackGenerator = if #available(iOS 17.5, *) {
                UIImpactFeedbackGenerator(style: .heavy, view: view)
            } else {
                UIImpactFeedbackGenerator(style: .heavy)
            }
            impactFeedbackGenerator.impactOccurred()
            resetCirclesVelocity()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
    
    private func resetCirclesVelocity() {
        let velocityRange = CircleVelocity.fast.range
        scene.queue.forEach { circle in
            circle.physicsBody?.velocity = CGVector(dx: velocityRange.randomElement()!, dy: velocityRange.randomElement()!)
        }
    }
}
