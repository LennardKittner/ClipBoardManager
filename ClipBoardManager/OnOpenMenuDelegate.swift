//
//  MenuDelegate.swift
//  CPUMonitor
//
//  Created by Lennard on 06.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa

class OnOpenMenuDelegate: NSObject, NSMenuDelegate {
    let onOpen: (NSMenu) -> Void
    
    init(onOpen: @escaping (NSMenu) -> Void) {
        self.onOpen = onOpen
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        onOpen(menu)
    }
    
}
