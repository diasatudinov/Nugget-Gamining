struct GameView: View {
    let round: Round

    private var scene: SKScene {
        let scene = GameScene(size: UIScreen.main.bounds.size, round: round)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            // Overlay for UI: spawn button and upgrade controls
            .overlay(
                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        Button(action: {
                            NotificationCenter.default.post(name: .spawnHamster, object: nil)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.orange)
                        }

                        // Example upgrade button
                        Button("Улучшить урон") {
                            NotificationCenter.default.post(name: .upgradeDamage, object: nil)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                    .padding()
                }
            )
    }
}