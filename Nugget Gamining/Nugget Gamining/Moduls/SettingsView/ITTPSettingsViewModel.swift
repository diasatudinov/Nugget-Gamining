//
//  ITTPSettingsViewModel.swift
//  Nugget Gamining
//
//


import SwiftUI

class ITTPSettingsViewModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
}
