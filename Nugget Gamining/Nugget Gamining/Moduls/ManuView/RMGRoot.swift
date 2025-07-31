//
//  RMGRoot.swift
//  Nugget Gamining
//
//


import SwiftUI

struct RMGRoot: View {
    
    @State private var isLoading = true
    @State var toUp: Bool = true
    @AppStorage("vers") var verse: Int = 0
    
    var body: some View {
        ZStack {
            if verse == 1 {
                RMGWVWrap(urlString: RMGLinks.winStarData)
            } else {
                VStack {
                    if isLoading {
                        NGLoaderView()
                    } else {
                        NGMenuView()
                            .onAppear {
                                AppDelegate.orientationLock = .landscape
                                setOrientation(.landscapeRight)
                            }
                            .onDisappear {
                                AppDelegate.orientationLock = .all
                            }
                            
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                updateIfNeeded()
            }
           
        }
    }
    
    func updateIfNeeded() {
        if RMGLinks.shared.finalURL == nil {
            Task {
                if await !RMGResolver.checking() {
                    verse = 1
                    toUp = false
                    isLoading = false
                    
                } else {
                    verse = 0
                    toUp = true
                    isLoading = false
                }
            }
        } else {
            isLoading = false
        }
        
        
    }
    
    func setOrientation(_ orientation: UIInterfaceOrientation) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let selector = NSSelectorFromString("setInterfaceOrientation:")
            if let responder = windowScene.value(forKey: "keyWindow") as? UIResponder, responder.responds(to: selector) {
                responder.perform(selector, with: orientation.rawValue)
            }
        }
    }
}

#Preview {
    RMGRoot()
}
