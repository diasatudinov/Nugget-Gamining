//
//  ContentView.swift
//  Nugget Gamining
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            RoundSelectionView()
                .navigationTitle("Выберите раунд")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
