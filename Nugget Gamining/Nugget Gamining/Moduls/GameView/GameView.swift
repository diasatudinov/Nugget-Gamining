//
//  GameView.swift
//  Nugget Gamining
//
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode

    let round: Round
    @State var gameScene: GameScene = {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    @StateObject var shopVM = RMGShopViewModel()
    @State private var collected: Int = 0
    @State private var gameOverMessage: String? = nil
    @State private var isWin = false
    var body: some View {
        ZStack {
            RMGSpriteViewContainer(scene: gameScene, level: round)
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 140:72)
                    }
                    Spacer()
                    VStack {
                        NGCoinBg(height: RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                        
                        ZStack {
                            Image(.carrotsBGNG)
                                .resizable()
                                .scaledToFit()
                            
                            Text("\(collected)")
                                .font(.system(size: RMGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                                .foregroundStyle(.white)
                                .textCase(.uppercase)
                                .offset(x: 20)
                            
                        }.frame(height: RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                    }
                }
                
                Spacer()
                HStack(spacing: 20) {
                    Spacer()
                    
                    VStack {
                        Button {
                            NotificationCenter.default.post(name: .spawnHamster, object: nil)
                        } label: {
                            ZStack {
                                Image(.unitsBtnNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 100:70)
                            }
                        }
                        
                        Button {
                            NotificationCenter.default.post(name: .upgradeHealth, object: nil)
                        } label: {
                            ZStack {
                                Image(.healthBtnNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 100:70)
                            }
                        }
                        
                    }
                    
                    VStack {
                        Button {
                            NotificationCenter.default.post(name: .upgradeDamage, object: nil)
                        } label: {
                            ZStack {
                                Image(.damageBtnNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 100:70)
                            }
                        }
                        
                        Button {
                            NotificationCenter.default.post(name: .upgradeSpeed, object: nil)
                        } label: {
                            ZStack {
                                Image(.speedBtnNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 100:70)
                            }
                        }
                    }
                }
                .padding()
            }
            
            if let gameOver = gameOverMessage {
                if isWin {
                    ZStack {
                        Image(.winBgNG)
                            .resizable()
                            .scaledToFit()
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Button {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image(.nextLevelBtnNG)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                                    }
                                    
                                    Button {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image(.menuBtnNG)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                                    }
                                }.padding(RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                                    .padding(.trailing, 20)
                            }
                        }
                    }.frame(width: RMGDeviceManager.shared.deviceType == .pad ? 900:500,height: RMGDeviceManager.shared.deviceType == .pad ? 500:280)

                } else {
                    ZStack {
                        Image(.loseBgNG)
                            .resizable()
                            .scaledToFit()
                        VStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(.retryBtnNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(.menuBtnNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 90:50)
                            }
                        }
                        
                        
                    }.frame(height: RMGDeviceManager.shared.deviceType == .pad ? 480:260)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .resourcesChanged)) { notif in
            if let value = notif.userInfo?["resources"] as? Int {
                collected = value
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameWon)) { _ in
            gameOverMessage = "Победа!"
            isWin = true
            RMGUser.shared.updateUserMoney(for: 20)
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameLost)) { _ in
            gameOverMessage = "Поражение"
            isWin = false
        }
        .background(
            ZStack {
                if let bgItem = shopVM.currentBgItem {
                    Image(bgItem.image)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
            }
        )
    }
}

// MARK: - Game Rounds

enum Round: Int, CaseIterable, Identifiable {
    case one = 1, two, three, four, five, six
    var id: Int { rawValue }
    var displayName: String { "Раунд \(rawValue)" }
}

// MARK: - Round Selection Screen

struct RoundSelectionView: View {
    var body: some View {
        List(Round.allCases) { round in
            NavigationLink(destination: GameView(round: round)) {
                Text(round.displayName)
                    .font(.headline)
                    .padding(.vertical, 8)
            }
        }
    }
}

// MARK: - Notifications for UI Actions

extension Notification.Name {
    static let spawnHamster   = Notification.Name("spawnHamster")
    static let upgradeHealth  = Notification.Name("upgradeHealth")
    static let upgradeDamage  = Notification.Name("upgradeDamage")
    static let upgradeSpeed   = Notification.Name("upgradeSpeed")
    static let resourcesChanged = Notification.Name("resourcesChanged")
    static let gameWon  = Notification.Name("gameWon")
    static let gameLost = Notification.Name("gameLost")
}

