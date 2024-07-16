//
//  RainViewController.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/12/24.
//

import SpriteKit

final class RainViewController: UIViewController {

    let rainView = RainView()
    
    override func loadView() {
        view = rainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .systemBackground
//        
//        view.addSubview(rainView)
//        rainView.center = view.center
//        rainView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }
}
