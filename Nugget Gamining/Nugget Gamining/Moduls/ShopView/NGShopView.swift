//
//  NGShopView.swift
//  Nugget Gamining
//
//

import SwiftUI

struct NGShopView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = RMGUser.shared
    @ObservedObject var viewModel: RMGShopViewModel
    @State var category: NGItemCategory = .skin
    var categoryArray: [NGItemCategory] = [.skin, .special, .background]
    
    var body: some View {
        ZStack {
            
            VStack {
                ZStack {
                    Image(.shopBgNG)
                        .resizable()
                        .scaledToFit()
                    
                    switch category {
                    case .skin:
                        HStack(spacing: 10) {
                            ForEach(viewModel.shopSkinItems, id: \.self) { skin in
                                shopSkinItem(skin: skin)
                            }
                        }
                    case .special:
                        HStack(spacing: 10) {
                            ForEach(viewModel.shopSpecialItems, id: \.self) { special in
                                shopSpecialItem(special: special)
                            }
                        }
                        
                        
                    case .background:
                        HStack(spacing: 10) {
                            ForEach(viewModel.shopBgItems, id: \.self) { bg in
                                shopBgItem(bg: bg)
                            }
                        }
                        
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            ForEach(categoryArray, id: \.self) { category in
                                Image("\(category.rawValue)BtnNG")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 80:46)
                                    .offset(y: self.category == category ? -10:0)
                                    .onTapGesture {
                                        withAnimation {
                                            self.category = category
                                        }
                                    }
                            }
                        }
                    }
                }.frame(height: RMGDeviceManager.shared.deviceType == .pad ? 600:300)
            }
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(.backIconNG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        
                        
                        
                        
                        Spacer()
                        
                        NGCoinBg()
                        
                    }.padding([.top])
                }
                
                Spacer()
            }
            
        }.background(
            ZStack {
                Image(.appBgNG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        
    }
    
    @ViewBuilder func shopSpecialItem(special: RMGItem) -> some View {
        ZStack {
            Image("\(special.icon)")
                .resizable()
                .scaledToFit()
            
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        Image(.itemLevelBgNG)
                            .resizable()
                            .scaledToFit()
                        Text("\(special.level)")
                            .font(.system(size: RMGDeviceManager.shared.deviceType == .pad ? 20:12))
                            .foregroundStyle(.white)
                    }.frame(height: RMGDeviceManager.shared.deviceType == .pad ? 60:33)
                }
                Spacer()
            }
            VStack {
                Spacer()
                
                Button {
                    viewModel.selectOrBuy(special, user: user, category: .special)
                } label: {
                    Image(viewModel.isMoneyEnough(item: special, user: user, category: .special) ? .tenBtnNG: .tenOffBtnNG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 40:27)
                    
                }
                .offset(y: 20)
            }
        }
        .frame(width: RMGDeviceManager.shared.deviceType == .pad ? 180:100 ,height: RMGDeviceManager.shared.deviceType == .pad ? 200:120)
    }
    
    @ViewBuilder func shopBgItem(bg: RMGItem) -> some View {
        ZStack {
            Image("\(bg.icon)")
                .resizable()
                .scaledToFit()
            VStack {
                Spacer()
                
                Button {
                    viewModel.selectOrBuy(bg, user: user, category: .background)
                } label: {
                    if viewModel.isPurchased(bg, category: .background) {
                        Image(viewModel.isCurrentItem(item: bg, category: .background) ? .selectedBtnNG: .selectBtnNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 40:27)
                    } else {
                        Image(viewModel.isMoneyEnough(item: bg, user: user, category: .background) ? .hundredBtnNG: .hundredOffBtnNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 40:27)
                    }
                }
                .offset(y: 20)
            }
        }
        .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 170:95)
    }
    
    @ViewBuilder func shopSkinItem(skin: RMGItem) -> some View {
        ZStack {
            Image("\(skin.icon)")
                .resizable()
                .scaledToFit()
            VStack {
                Spacer()
                
                Button {
                    viewModel.selectOrBuy(skin, user: user, category: .skin)
                } label: {
                    if viewModel.isPurchased(skin, category: .skin) {
                        Image(viewModel.isCurrentItem(item: skin, category: .skin) ? .selectedBtnNG: .selectBtnNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 40:27)
                    } else {
                        Image(viewModel.isMoneyEnough(item: skin, user: user, category: .skin) ? .hundredBtnNG: .hundredOffBtnNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 40:27)
                    }
                }
                .offset(y: 20)
            }
        }
        .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 170:95)
    }
}

#Preview {
    NGShopView(viewModel: RMGShopViewModel())
}
