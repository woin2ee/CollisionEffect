//
//  CollisionEffectViewController.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/16/24.
//

import SpriteKit

final class CollisionEffectViewController: UIViewController {

    let scene: CollisionEffectScene
    
    init() {
        scene = CollisionEffectScene()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let skView = SKView()
//        skView.ignoresSiblingOrder = true
        view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = view as? SKView {
            view.presentScene(scene)
        }
    }
    
    override func viewWillLayoutSubviews() {
        scene.backgroundGradientNode.size = view.frame.size
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let impactFeedbackGenerator = if #available(iOS 17.5, *) {
                UIImpactFeedbackGenerator(style: .heavy, view: view)
            } else {
                UIImpactFeedbackGenerator(style: .heavy)
            }
            impactFeedbackGenerator.impactOccurred()
            scene.resetCirclesVelocity()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
}
