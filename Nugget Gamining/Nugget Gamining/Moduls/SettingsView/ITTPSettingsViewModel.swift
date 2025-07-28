import SwiftUI

class ITTPSettingsViewModel: ObservableObject {
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("vibraEnabled") var vibraEnabled: Bool = true
}
