//
//  CircleViewController.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/16/24.
//

import SpriteKit

final class CircleViewController: UIViewController {
    
    let circleScene: CircleScene
    
    init() {
        circleScene = CircleScene()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let view = view as? SKView {
            view.presentScene(circleScene)
        }
    }
}
