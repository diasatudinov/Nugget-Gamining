import SwiftUI

class RMGLinks {
    
    static let shared = RMGLinks()
    
    static let winStarData = "https://remilgrand.run/get"
    
    @AppStorage("finalUrl") var finalURL: URL?
    
    
}