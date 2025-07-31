//
//  NGAchievementsView.swift
//  Nugget Gamining
//
//

import SwiftUI

struct NGAchievementsView: View {
    @StateObject var user = NGUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: NGAchievementsViewModel
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack(alignment: .top) {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconNG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: NGDeviceManager.shared.deviceType == .pad ? 100:60)
                        }
                        
                        Spacer()
                        NGCoinBg()
                    }
                    
                    HStack {
                        Image(.achiTextNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 150:80)
                    }
                }.padding([.top])
                
                HStack {
                    ForEach(viewModel.achievements, id: \.self) { achieve in
                        achievementItem(item: achieve)
                            .onTapGesture {
                                viewModel.achieveToggle(achieve)
                            }
                    }
                    
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
    
    @ViewBuilder func achievementItem(item: MGAchievement) -> some View {
        
        ZStack {
            Image(item.image)
                .resizable()
                .scaledToFit()
            
            
            VStack(spacing: 0) {
                
                Spacer()
                
                Image(item.isAchieved ? .receivedIconNG: .getIconNG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 80:45)
                    .offset(y: NGDeviceManager.shared.deviceType == .pad ? 40:25)
                
            }
        }.frame(height: NGDeviceManager.shared.deviceType == .pad ? 350:200)
    }
}

#Preview {
    NGAchievementsView(viewModel: NGAchievementsViewModel())
}
