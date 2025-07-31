//
//  RMGSpriteViewContainer.swift
//  Nugget Gamining
//
//


import SwiftUI
import SpriteKit


struct RMGSpriteViewContainer: UIViewRepresentable {
    @StateObject var user = RMGUser.shared
    var scene: GameScene
    var level: Round
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        scene.round = level
       
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.frame = UIScreen.main.bounds
    }
}
