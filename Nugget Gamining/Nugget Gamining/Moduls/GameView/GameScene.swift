class GameScene: SKScene {
    let round: Round
    private var carrotNodes: [SKSpriteNode] = []
    private var ratNodes: [SKSpriteNode] = []
    private var resources: Int = 0
    private var spawnCost: Int = 10
    private var upgradeCostMultiplier: Double = 1.2

    init(size: CGSize, round: Round) {
        self.round = round
        super.init(size: size)
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func didMove(to view: SKView) {
        setupLevel()
        subscribeToNotifications()
    }

    private func setupLevel() {
        loadCarrots(count: round.rawValue * 10)
        loadRats(count: round.rawValue * 5)
    }

    private func loadCarrots(count: Int) {
        for _ in 0..<count {
            let carrot = SKSpriteNode(imageNamed: "carrot")
            carrot.name = "carrot"
            carrot.position = randomPoint()
            addChild(carrot)
            carrotNodes.append(carrot)
        }
    }

    private func loadRats(count: Int) {
        for _ in 0..<count {
            let rat = SKSpriteNode(imageNamed: "rat")
            rat.name = "rat"
            rat.position = randomPoint()
            addChild(rat)
            ratNodes.append(rat)
        }
    }

    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(spawnHamster), name: .spawnHamster, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upgradeDamage), name: .upgradeDamage, object: nil)
        // Add other upgrades similarly
    }

    @objc private func spawnHamster() {
        guard resources >= spawnCost else { return }
        resources -= spawnCost
        spawnCost = Int(Double(spawnCost) * upgradeCostMultiplier)

        let hamster = SKSpriteNode(imageNamed: "hamster")
        hamster.name = "hamster"
        hamster.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(hamster)
        // Set up AI behavior, e.g. SKAction sequence targeting nearest carrot or rat
    }

    @objc private func upgradeDamage() {
        guard resources > 0 else { return }
        // Increase hamster damage stat stored in userData or separate manager
        resources -= 1
    }

    override func update(_ currentTime: TimeInterval) {
        // AI logic: each hamster seeks nearest carrot or rat, moves and attacks
    }

    private func randomPoint() -> CGPoint {
        let padding: CGFloat = 50
        let x = CGFloat.random(in: padding...(size.width - padding))
        let y = CGFloat.random(in: padding...(size.height - padding))
        return CGPoint(x: x, y: y)
    }
}