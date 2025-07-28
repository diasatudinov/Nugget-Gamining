//
//  NGCoinBg.swift
//  Nugget Gamining
//
//

import SwiftUI

struct NGCoinBg: View {
    @StateObject var user = RMGUser.shared
    var body: some View {
        ZStack {
            Image(.coinsBgNG)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: RMGDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                .foregroundStyle(.white)
                .textCase(.uppercase)
                .offset(x: 20)
            
            
            
        }.frame(height: RMGDeviceManager.shared.deviceType == .pad ? 120:70)
        
    }
}

#Preview {
    NGCoinBg()
}
