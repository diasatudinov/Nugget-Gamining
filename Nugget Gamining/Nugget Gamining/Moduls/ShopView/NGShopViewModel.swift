//
//  NGShopViewModel.swift
//  Nugget Gamining
//
//


import SwiftUI


final class NGShopViewModel: ObservableObject {
    // MARK: – Shop catalogues
    @Published var shopBgItems: [RMGItem] = [
        RMGItem(name: "bg1", image: "bgImage1NG", icon: "gameBgIcon1NG", price: 100),
        RMGItem(name: "bg2", image: "bgImage2NG", icon: "gameBgIcon2NG", price: 100),
        RMGItem(name: "bg3", image: "bgImage3NG", icon: "gameBgIcon3NG", price: 100),
        RMGItem(name: "bg4", image: "bgImage4NG", icon: "gameBgIcon4NG", price: 100),
    ]
    @Published var shopSpecialItems: [RMGItem] = [
        RMGItem(name: "special1", image: "specialImage1NG", icon: "specialIcon1NG", price: 10),
        RMGItem(name: "special2", image: "specialImage2NG", icon: "specialIcon2NG", price: 10),
        RMGItem(name: "special3", image: "specialImage3NG", icon: "specialIcon3NG", price: 10),
    ] {
        didSet { saveBoughtSpecials() }
    }
    @Published var shopSkinItems: [RMGItem] = [
        RMGItem(name: "skin1", image: "skinImage1NG", icon: "skinIcon1NG", price: 100),
        RMGItem(name: "skin2", image: "skinImage2NG", icon: "skinIcon2NG", price: 100),
        RMGItem(name: "skin3", image: "skinImage3NG", icon: "skinIcon3NG", price: 100),
        RMGItem(name: "skin4", image: "skinImage4NG", icon: "skinIcon4NG", price: 100),
    ]
    
    // MARK: – Bought
    @Published var boughtBgItems: [RMGItem] = [
        RMGItem(name: "bg1", image: "bgImage1NG", icon: "gameBgIcon1NG", price: 100)
    ] {
        didSet { saveBoughtBg() }
    }

    @Published var boughtSkinItems: [RMGItem] = [
        RMGItem(name: "skin1", image: "skinImage1NG", icon: "skinIcon1NG", price: 100)
    ] {
        didSet { saveBoughtSkins() }
    }
    
    // MARK: – Current selections
    @Published var currentBgItem: RMGItem? {
        didSet { saveCurrentBg() }
    }
    @Published var currentSkinItem: RMGItem? {
        didSet { saveCurrentSkin() }
    }
    
    // MARK: – UserDefaults keys
    private let bgKey            = "currentBgRMG"
    private let boughtBgKey      = "boughtBgRMG"
    private let specialKey       = "currentSpecialRMG"
    private let boughtSpecialKey = "boughtSpecialRMG"
    private let skinKey          = "currentSkinNG1"
    private let boughtSkinKey    = "boughtSkinNG1"
    
    // MARK: – Init
    init() {
        loadCurrentBg()
        loadBoughtBg()
        
        loadBoughtSpecial()
        
        loadCurrentSkin()
        loadBoughtSkins()
    }
    
    // MARK: – Save / Load Backgrounds
    private func saveCurrentBg() {
        guard let item = currentBgItem,
              let data = try? JSONEncoder().encode(item)
        else { return }
        UserDefaults.standard.set(data, forKey: bgKey)
    }
    private func loadCurrentBg() {
        if let data = UserDefaults.standard.data(forKey: bgKey),
           let item = try? JSONDecoder().decode(RMGItem.self, from: data) {
            currentBgItem = item
        } else {
            currentBgItem = shopBgItems.first
        }
    }
    private func saveBoughtBg() {
        guard let data = try? JSONEncoder().encode(boughtBgItems) else { return }
        UserDefaults.standard.set(data, forKey: boughtBgKey)
    }
    private func loadBoughtBg() {
        if let data = UserDefaults.standard.data(forKey: boughtBgKey),
           let items = try? JSONDecoder().decode([RMGItem].self, from: data) {
            boughtBgItems = items
        }
    }
    
    // MARK: – Save / Load Specials
    private func saveBoughtSpecials() {
        guard let data = try? JSONEncoder().encode(shopSpecialItems) else { return }
        UserDefaults.standard.set(data, forKey: boughtSpecialKey)
    }
    private func loadBoughtSpecial() {
        if let data = UserDefaults.standard.data(forKey: boughtSpecialKey),
           let items = try? JSONDecoder().decode([RMGItem].self, from: data) {
            shopSpecialItems = items
        }
    }
    
    // MARK: – Save / Load Skins
    private func saveCurrentSkin() {
        guard let item = currentSkinItem,
              let data = try? JSONEncoder().encode(item)
        else { return }
        UserDefaults.standard.set(data, forKey: skinKey)
    }
    private func loadCurrentSkin() {
        if let data = UserDefaults.standard.data(forKey: skinKey),
           let item = try? JSONDecoder().decode(RMGItem.self, from: data) {
            currentSkinItem = item
        } else {
            currentSkinItem = shopSkinItems.first
        }
    }
    private func saveBoughtSkins() {
        guard let data = try? JSONEncoder().encode(boughtSkinItems) else { return }
        UserDefaults.standard.set(data, forKey: boughtSkinKey)
    }
    private func loadBoughtSkins() {
        if let data = UserDefaults.standard.data(forKey: boughtSkinKey),
           let items = try? JSONDecoder().decode([RMGItem].self, from: data) {
            boughtSkinItems = items
        }
    }
    
    // MARK: – Example buy action
    func buy(_ item: RMGItem, category: NGItemCategory) {
        switch category {
        case .background:
            guard !boughtBgItems.contains(item) else { return }
            boughtBgItems.append(item)
        case .special:
            
            if let index = shopSpecialItems.firstIndex(where: { $0.name == item.name }) {
                shopSpecialItems[index].rate += 0.1
                shopSpecialItems[index].level += 1
            }
        case .skin:
            guard !boughtSkinItems.contains(item) else { return }
            boughtSkinItems.append(item)
        }
    }
    
    func isPurchased(_ item: RMGItem, category: NGItemCategory) -> Bool {
        switch category {
        case .background:
            return boughtBgItems.contains(where: { $0.name == item.name })
        case .special:
            return false
        case .skin:
            return boughtSkinItems.contains(where: { $0.name == item.name })
        }
    }

    func selectOrBuy(_ item: RMGItem, user: RMGUser, category: NGItemCategory) {
        
        switch category {
        case .background:
            if isPurchased(item, category: .background) {
                currentBgItem = item
            } else {
                guard user.money >= item.price else {
                    return
                }
                user.minusUserMoney(for: item.price)
                buy(item, category: .background)
            }
        case .special:
            guard user.money >= item.price else {
                return
            }
            user.minusUserMoney(for: item.price)
            buy(item, category: .special)
            
            
        case .skin:
            if isPurchased(item, category: .skin) {
                currentSkinItem = item
            } else {
                guard user.money >= item.price else {
                    return
                }
                user.minusUserMoney(for: item.price)
                buy(item, category: .skin)
            }
        }
    }
    
    func isMoneyEnough(item: RMGItem, user: RMGUser, category: NGItemCategory) -> Bool {
        user.money >= item.price
    }
    
    func isCurrentItem(item: RMGItem, category: NGItemCategory) -> Bool {
        switch category {
        case .background:
            guard let currentItem = currentBgItem, currentItem.name == item.name else {
                return false
            }
            
            return true
            
        case .special:
            return false
        case .skin:
            guard let currentItem = currentSkinItem, currentItem.name == item.name else {
                return false
            }
            
            return true
        }
    }
}

enum NGItemCategory: String {
    case background = "background"
    case special = "special"
    case skin = "skin"
}

struct RMGItem: Codable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var icon: String
    var price: Int
    var rate: Double = 1.0
    var level: Int = 1
}
