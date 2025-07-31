//
//  NGSettingsView.swift
//  Nugget Gamining
//
//

import SwiftUI

struct NGSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settingsVM: NGSettingsViewModel
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: 0) {
                
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 140:72)
                    }
                    Spacer()
                    
                    NGCoinBg()
                }.padding([.horizontal, .top])
                
                
                ZStack {
                    
                    Image(.settingsBgNG)
                        .resizable()
                        .scaledToFit()
                    
                    HStack(spacing: 60) {
                        Image(.soundsTextNG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: NGDeviceManager.shared.deviceType == .pad ? 40:26)
                        
                        Button {
                            withAnimation {
                                settingsVM.soundEnabled.toggle()
                            }
                        } label: {
                            HStack(spacing: 20) {
                                
                                Image(settingsVM.soundEnabled ? .onNG:.yesNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 120:72)
                                
                                Image(settingsVM.soundEnabled ? .noNG:.offNG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: NGDeviceManager.shared.deviceType == .pad ? 120:72)
                            }
                        }
                    }.padding(.horizontal, NGDeviceManager.shared.deviceType == .pad ? 60:32)
                }.frame(width: NGDeviceManager.shared.deviceType == .pad ? 750:440,height: NGDeviceManager.shared.deviceType == .pad ? 400:260)
                Spacer()
            }.padding()
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
    NGSettingsView(settingsVM: NGSettingsViewModel())
}
