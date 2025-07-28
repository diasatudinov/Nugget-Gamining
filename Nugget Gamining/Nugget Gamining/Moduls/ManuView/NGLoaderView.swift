//
//  NGLoaderView.swift
//  Nugget Gamining
//
//

import SwiftUI

struct NGLoaderView: View {
    @State private var scale: CGFloat = 1.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?
    var body: some View {
        ZStack {
            
            VStack {
              
                VStack(spacing: 0) {
                    Image(.loadingLogoNG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                    
                    Text("Ready When You Are")
                        .font(.custom(Fonts.regular.rawValue, size: 64))
                        .foregroundStyle(.appRed)
                        .textCase(.uppercase)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                        .onAppear {
                            scale = 0.8
                        }
                       
                }
                .padding(.vertical, 28)
                ZStack {
                    Image(.loaderBorderNG)
                        .resizable()
                        .scaledToFit()
                                        
                    Image(.loaderBgNG)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 385)
                        .mask(
                            Rectangle()
                                .frame(width: progress * 385)
                                .padding(.trailing, (1 - progress) * 385)
                        )
                }
                .frame(width: 400)
            }
            
            
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += 0.01
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    NGLoaderView()
}
