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
    var body: some View {
        ZStack {
             
            VStack {
                ZStack {
                    Image(.shopBgNG)
                        .resizable()
                        .scaledToFit()
                    
//                    ZStack {
//                        HStack {
//                            ForEach(currentItems, id: \.self) { item in
//                                shopItem(item: item)
//                                
//                                
//                            }
//                        }
//                        
//                        HStack {
//                            Button(action: previousPage) {
//                                Image(.arrowRMG)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 150:80)
//                                    .scaleEffect(x: -1, y: 1)
//                            }
//                            .disabled(currentIndex == 0)
//                            
//                            Spacer()
//                            
//                            Button(action: nextPage) {
//                                Image(.arrowRMG)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 150:80)
//                            }
//                            .disabled(currentIndex + itemsPerPage >= viewModel.shopBgItems.count)
//                        }
//                    }.frame(width: RMGDeviceManager.shared.deviceType == .pad ? 1000:500)
                    
                    
                }.frame(height: RMGDeviceManager.shared.deviceType == .pad ? 600:300)
            }
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        VStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                
                            } label: {
                                Image(.backIconNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 100:50)
                            }
                            
                            NGCoinBg().opacity(0)
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
}

#Preview {
    NGShopView(viewModel: RMGShopViewModel())
}
