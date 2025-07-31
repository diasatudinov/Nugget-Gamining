//
//  NGDeviceManager.swift
//  Nugget Gamining
//
//


import UIKit

class NGDeviceManager {
    static let shared = NGDeviceManager()
    
    var deviceType: UIUserInterfaceIdiom
    
    private init() {
        self.deviceType = UIDevice.current.userInterfaceIdiom
    }
}
