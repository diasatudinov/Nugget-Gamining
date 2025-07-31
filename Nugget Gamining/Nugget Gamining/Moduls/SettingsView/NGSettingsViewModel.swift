//
//  NGSettingsViewModel.swift
//  Nugget Gamining
//
//


import SwiftUI

class NGSettingsViewModel: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
}
