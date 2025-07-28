//
//  NGMenuView.swift
//  Nugget Gamining
//
//

import SwiftUI

struct NGMenuView: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showMiniGames = false
    @State private var showSettings = false
    @State private var showCalendar = false
    @State private var showDailyTask = false
    
    //    @StateObject var achievementVM = RMGAchievementsViewModel()
    //    @StateObject var settingsVM = RMGSettingsViewModel()
    //    @StateObject var calendarVM = RMGCalendarViewModel()
    //    @StateObject var shopVM = RMGShopViewModel()
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(.settingsIconNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Spacer()
                    
                    NGCoinBg()
                }.padding()
                
                
                VStack(spacing: 7) {
                    Button {
                        showGame = true
                    } label: {
                        Image(.playIconNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 120:70)
                    }
                    
                    Button {
                        showAchievement = true
                    } label: {
                        Image(.achievementsIconNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 120:70)
                    }
                    
                    Button {
                        showShop = true
                    } label: {
                        Image(.shopIconNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 120:70)
                    }
                    
                    Button {
                        showDailyTask = true
                    } label: {
                        Image(.dailyTasksIconNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 120:70)
                    }
                }
            }
        }
        .background(
            ZStack {
                Image(.appBgNG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .fullScreenCover(isPresented: $showGame) {
//            RMGLevelsMainGameView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $showAchievement) {
//            RMGAchievementsView(viewModel: achievementVM)
        }
        .fullScreenCover(isPresented: $showShop) {
//            RMGShopView(viewModel: shopVM)
        }
        .fullScreenCover(isPresented: $showSettings) {
//            RMGSettingsView(settingsVM: settingsVM)
        }
        .fullScreenCover(isPresented: $showDailyTask) {
//            RMGDailyTaskView()
        }
    }
    
}

#Preview {
    NGMenuView()
}
