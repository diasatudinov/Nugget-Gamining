import SwiftUI
import SpriteKit


struct RMGSpriteViewContainer: UIViewRepresentable {
    @StateObject var user = RMGUser.shared
    var scene: RMGGameScene
    @Binding var winner: String?
    @Binding var sendPercent: CGFloat
    var level: Int
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        scene.scaleMode = .resizeFill
        scene.victoryHandler = { name in
            DispatchQueue.main.async {
                self.winner = name
            }
        }
        scene.levelIndex = level
        scene.sendPercent = sendPercent
       
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.frame = UIScreen.main.bounds
    }
}