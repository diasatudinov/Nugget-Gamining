//
//  NGDailyTasksView.swift
//  Nugget Gamining
//
//

import SwiftUI

struct NGDailyTasksView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var isRecieved = false
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
                            .frame(
                                height: RMGDeviceManager.shared.deviceType == .pad ? 140:72
                            )
                    }
                    Spacer()
                    
                    NGCoinBg()
                }.padding([.horizontal, .top])
                
                
                ZStack {
                    
                    Image(.dailyTasksBgNG)
                        .resizable()
                        .scaledToFit()
                    
                    VStack {
                        Spacer()
                        
                        Button {
                            withAnimation {
                                isRecieved.toggle()
                            }
                        } label: {
                            
                            
                            Image(isRecieved ? .recievedBtnNG:.recieveBtnNG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: RMGDeviceManager.shared.deviceType == .pad ? 120:72)
                        }
                    }
                }.frame(
                    width: RMGDeviceManager.shared.deviceType == .pad ? 750:440,
                    height: RMGDeviceManager.shared.deviceType == .pad ? 400:260
                )
                
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
    NGDailyTasksView()
}
