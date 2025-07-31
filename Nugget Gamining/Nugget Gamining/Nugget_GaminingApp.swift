//
//  Nugget_GaminingApp.swift
//  Nugget Gamining
//
//

import SwiftUI

@main
struct Nugget_GaminingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RMGRoot()
                .preferredColorScheme(.light)
        }
    }
}
