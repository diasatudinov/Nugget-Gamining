//
//  NGDeviceManager.swift
//  Nugget Gamining
//
//


import UIKit

class RMGDeviceManager {
    static let shared = RMGDeviceManager()
    
    var deviceType: UIUserInterfaceIdiom
    
    private init() {
        self.deviceType = UIDevice.current.userInterfaceIdiom
    }
}
