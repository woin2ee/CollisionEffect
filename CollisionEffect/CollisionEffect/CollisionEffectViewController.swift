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
}
