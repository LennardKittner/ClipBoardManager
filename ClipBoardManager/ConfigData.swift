//
//  State.swift
//  CPUMonitor
//
//  Created by Lennard on 05.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Foundation

class ConfigData :NSObject, NSCopying {
    @objc public var startAtLogin :Bool
    @objc public var clippingCount :Int
    @objc public var previewWidth :Int
    @objc public var refreshTime :Double
    
    override init() {
        startAtLogin = false
        clippingCount = 10
        previewWidth = 40
        refreshTime = 0.5
    }
    
    init(copyFrom: ConfigData) {
        self.startAtLogin = copyFrom.startAtLogin
        self.clippingCount = copyFrom.clippingCount
        self.previewWidth = copyFrom.previewWidth
        self.refreshTime = copyFrom.refreshTime
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return copy()
    }
    
    override func copy() -> Any {
        return ConfigData(copyFrom: self)
    }
}
