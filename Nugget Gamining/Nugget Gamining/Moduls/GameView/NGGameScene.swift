//
//  GameScene.swift
//  Nugget Gamining
//

import SpriteKit
import SwiftUI

struct PhysicsCategory {
    static let none: UInt32       = 0
    static let carrot: UInt32     = 0x1 << 0
    static let rat: UInt32        = 0x1 << 1
    static let hamster: UInt32    = 0x1 << 2
}

struct GameButton: View {
    let system: String
    let label: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: system)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - GameScene
class NGGameScene: SKScene, SKPhysicsContactDelegate {
    var round: Round?
    let shopVM = NGShopViewModel()
    private var carrots: [SKSpriteNode] = []
    private var rats:    [SKSpriteNode] = []
    private var resources = 0
    
    // Hamster stats
    private var baseHamHealth: CGFloat = 3.0
    private var baseHamDamage: CGFloat = 0.5
    private var baseHamSpeed:  CGFloat = 60.0
    // Rat stats
    private let ratBaseHealth: CGFloat = 2.0
    private let ratBaseDamage: CGFloat = 0.5
    private let ratSpeed:      CGFloat = 50.0
    
    private var spawnCost = 5
    private let costMultiplier: Double = 1.2
    
    private var hamsterFrames: [SKTexture] = []
    private var ratFrames:     [SKTexture] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = .clear
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        loadAttackTextures()
    }
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func loadAttackTextures() {
        guard let skinItem = shopVM.currentSkinItem else { return }
        hamsterFrames = (1...2).map { SKTexture(imageNamed: "\(skinItem.name)hamster_attack\($0)") }
        ratFrames     = (1...2).map { SKTexture(imageNamed: "\(skinItem.name)rat_attack\($0)") }
    }
    
    override func didMove(to view: SKView) {
        setupLevel()
        spawnInitialHamsters(count: 2)
        subscribeNotifications()
    }
    
    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onSpawn),  name: .spawnHamster,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHealth), name: .upgradeHealth, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDamage), name: .upgradeDamage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSpeed),  name: .upgradeSpeed,  object: nil)
    }
    
    @objc private func onSpawn() {
        guard resources >= spawnCost else { return }
        resources -= spawnCost
        NotificationCenter.default.post(name: .resourcesChanged, object: nil, userInfo: ["resources": resources])
        spawnCost = Int(Double(spawnCost) * costMultiplier)
        let x = CGFloat.random(in: 100...UIScreen.main.bounds.width - 100)
        spawnHamster(at: CGPoint(x: x, y: hamsterY()))
    }
    @objc private func onHealth() { baseHamHealth += 0.3 }
    @objc private func onDamage() { baseHamDamage += 0.3 }
    @objc private func onSpeed()  { baseHamSpeed  += 0.3 }
    
    private func setupLevel() {
        guard let round = round else { return }
        switch round {
        case .one:
            loadCarrots(count: round.rawValue * 10)
            loadRats(count: round.rawValue * 4)
        case .two:
            loadCarrots(count: round.rawValue * 10)
            loadRats(count: round.rawValue * 3)
        case .three:
            loadCarrots(count: round.rawValue * 10)
            loadRats(count: round.rawValue * 3)
        case .four:
            loadCarrots(count: round.rawValue * 6)
            loadRats(count: round.rawValue * 4)
        case .five:
            loadCarrots(count: round.rawValue * 5)
            loadRats(count: round.rawValue * 4)
        default:
            loadCarrots(count: round.rawValue * 3)
            loadRats(count: round.rawValue * 2)
        
        }
        
    
    }
    
    private func loadCarrots(count: Int) {
        for _ in 0..<count {
            let big = Bool.random()
            let img = big ? "bigCarrot" : "carrot"
            let health: CGFloat = big ? 4.0 : 2.0
            let reward = Int(health)
            let c = SKSpriteNode(imageNamed: img)
            c.name = "carrot"
            c.zPosition = 1  // морковки впереди хомяков
            let sizeVal: CGFloat = big ? 36 : 26
            c.size = CGSize(width: sizeVal, height: sizeVal)
            c.position = randomPoint()
            c.userData = ["hp": health, "reward": reward]
            c.physicsBody = SKPhysicsBody(circleOfRadius: sizeVal/2)
            c.physicsBody?.isDynamic = false
            c.physicsBody?.categoryBitMask = PhysicsCategory.carrot
            c.physicsBody?.contactTestBitMask = PhysicsCategory.hamster
            addChild(c)
            carrots.append(c)
        }
    }
    
    private func loadRats(count: Int) {
        guard let skinItem = shopVM.currentSkinItem else { return }
        for _ in 0..<count {
            let r = SKSpriteNode(imageNamed: "\(skinItem.name)rat")
            r.name = "rat"
            let aspect = r.size.height / r.size.width
            r.size = CGSize(width: 20, height: 20 * aspect)
            r.position = randomPoint()
            r.userData = ["hp": ratBaseHealth, "damage": ratBaseDamage]
            let hpLabel = SKLabelNode(text: "\(Int(ratBaseHealth))")
            hpLabel.fontSize = 12; hpLabel.fontColor = .red
            hpLabel.position = CGPoint(x: 0, y: r.size.height/2 + 8)
            hpLabel.zPosition = 1
            r.addChild(hpLabel)
            r.physicsBody = SKPhysicsBody(circleOfRadius: r.size.width/2)
            r.physicsBody?.isDynamic = true
            r.physicsBody?.categoryBitMask = PhysicsCategory.rat
            r.physicsBody?.collisionBitMask = PhysicsCategory.carrot
            r.physicsBody?.contactTestBitMask = PhysicsCategory.hamster
            r.physicsBody?.allowsRotation = false
            r.physicsBody?.linearDamping = 0
            addChild(r)
            rats.append(r)
        }
    }
    
    private func spawnInitialHamsters(count: Int) {
        guard let round = round else { return }
        let spacing = UIScreen.main.bounds.width / CGFloat(count + 1)
        for i in 1...(round.rawValue * count) {
            let x = CGFloat.random(in: 100...UIScreen.main.bounds.width - 100)
            spawnHamster(at: CGPoint(x: x, y: hamsterY()))
        }
    }
    
    private func hamsterY() -> CGFloat { hamsterSize().height/2 + 20 }
    private func hamsterSize() -> CGSize {
        guard let skinItem = shopVM.currentSkinItem else { return CGSize() }
        let t = SKSpriteNode(imageNamed: "\(skinItem.name)hamster")
        let aspect = t.size.height / t.size.width
        return CGSize(width: 26, height: 26 * aspect)
    }
    
    private func spawnHamster(at pos: CGPoint) {
        guard let skinItem = shopVM.currentSkinItem else { return }
        let h = SKSpriteNode(imageNamed: "\(skinItem.name)hamster")
        h.name = "hamster"
        let aspect = h.size.height / h.size.width
        h.size = CGSize(width: 26, height: 26 * aspect)
        h.position = pos
        h.zPosition = 0  // позади морковок
        h.userData = ["hp": baseHamHealth, "damage": baseHamDamage]
        let hpLabel = SKLabelNode(text: "\(Int(baseHamHealth))")
        hpLabel.fontSize = 12; hpLabel.fontColor = .green
        hpLabel.position = CGPoint(x: 0, y: h.size.height/2 + 8)
        hpLabel.zPosition = 1
        h.addChild(hpLabel)
        h.physicsBody = SKPhysicsBody(circleOfRadius: h.size.width/2)
        h.physicsBody?.isDynamic = true
        h.physicsBody?.categoryBitMask = PhysicsCategory.hamster
        h.physicsBody?.collisionBitMask = PhysicsCategory.carrot | PhysicsCategory.rat
        h.physicsBody?.contactTestBitMask = PhysicsCategory.carrot | PhysicsCategory.rat
        h.physicsBody?.allowsRotation = false
        h.physicsBody?.linearDamping = 0
        addChild(h)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for sprite in children.compactMap({ $0 as? SKSpriteNode }) {
            guard let body = sprite.physicsBody else { continue }
            switch sprite.name {
            case "hamster":
                let target = nearest(sprite, in: rats) ?? nearest(sprite, in: carrots)
                if let t = target {
                    orient(sprite, to: t.position)
                    move(body, toward: t.position, speed: baseHamSpeed, from: sprite.position)
                } else { body.velocity = .zero }
            case "rat":
                let hamsters = children.compactMap({ $0 as? SKSpriteNode }).filter({ $0.name == "hamster" })
                if let t = nearest(sprite, in: hamsters) {
                    orient(sprite, to: t.position)
                    move(body, toward: t.position, speed: ratSpeed, from: sprite.position)
                } else { body.velocity = .zero }
            default: break
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let A = contact.bodyA.node as? SKSpriteNode,
              let B = contact.bodyB.node as? SKSpriteNode else { return }
        // Hamster-Carrot collision
        if (A.name=="hamster"&&B.name=="carrot")||(A.name=="carrot"&&B.name=="hamster") {
            let ham = A.name=="hamster" ? A : B
            let car = A.name=="carrot"  ? A : B
            if let hp = car.userData?["hp"] as? CGFloat,
               let reward = car.userData?["reward"] as? Int,
               let hamD = ham.userData?["damage"] as? CGFloat {
                let newHP = hp - hamD
                if newHP <= 0 {
                    car.removeFromParent()
                    resources += reward
                    carrots.removeAll { $0 == car }
                    // Notify UI of resource change
                    NotificationCenter.default.post(name: .resourcesChanged, object: nil, userInfo: ["resources": resources])
                } else {
                    car.userData?["hp"] = newHP
                }
            }
        }
        // Hamster-Rat collision
        if (A.name=="hamster"&&B.name=="rat")||(A.name=="rat"&&B.name=="hamster") {
            let ham = A.name=="hamster" ? A : B
            let rat = A.name=="rat"     ? A : B
            if let rHP = rat.userData?["hp"] as? CGFloat,
               let hamD = ham.userData?["damage"] as? CGFloat {
                let newR = rHP - hamD
                if newR <= 0 {
                    rat.removeFromParent()
                    resources += 2
                    rats.removeAll { $0 == rat }
                    NotificationCenter.default.post(name: .resourcesChanged, object: nil, userInfo: ["resources": resources])
                } else { rat.userData?["hp"] = newR }
            }
            if let hHP = ham.userData?["hp"] as? CGFloat,
               let rD = rat.userData?["damage"] as? CGFloat {
                let newH = hHP - rD
                if newH <= 0 {
                    ham.removeFromParent()
                } else { ham.userData?["hp"] = newH }
            }
        }
        
        checkEndConditions()
    }

    // Utilities
    private func nearest(_ s: SKSpriteNode, in list: [SKSpriteNode]) -> SKSpriteNode? {
        return list.filter({ $0.parent != nil }).min(by: {
            let d1 = hypot($0.position.x - s.position.x, $0.position.y - s.position.y)
            let d2 = hypot($1.position.x - s.position.x, $1.position.y - s.position.y)
            return d1 < d2
        })
    }
    private func orient(_ s: SKSpriteNode, to p: CGPoint) {
        let dx = p.x - s.position.x, dy = p.y - s.position.y
        s.zRotation = atan2(dy, dx) - .pi/2
    }
    private func move(_ b: SKPhysicsBody, toward p: CGPoint, speed: CGFloat, from pos: CGPoint) {
        let dx = p.x - pos.x, dy = p.y - pos.y
        let dist = hypot(dx, dy)
        b.velocity = dist > 1 ? CGVector(dx: dx/dist * speed, dy: dy/dist * speed) : .zero
    }
    private func randomPoint() -> CGPoint {
        let pad: CGFloat = 50
        return CGPoint(x: CGFloat.random(in: pad...(size.width-pad)),
                       y: CGFloat.random(in: pad...(size.height-pad)))
    }
    
    private func checkEndConditions() {
        // Victory: no carrots and no rats
        if carrots.isEmpty && rats.isEmpty {
            NotificationCenter.default.post(name: .gameWon, object: nil)
        }
        // Defeat: no hamsters
        let hamstersExist = children.contains(where: { ($0 as? SKSpriteNode)?.name == "hamster" })
        if !hamstersExist {
            NotificationCenter.default.post(name: .gameLost, object: nil)
        }
    }
}
