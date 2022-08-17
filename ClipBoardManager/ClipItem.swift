//
//  ClipItem.swift
//  ClipBoardManager
//
//  Created by Lennard on 16.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa

class ClipItem: NSMenuItem {
    
    var entry: CBElement?
    
    init() {
        super.init(title: "", action: nil, keyEquivalent: "")
        action = #selector(copyEntry(_:))
        target = self
    }
    
    convenience init(entry: CBElement, maxLength: Int) {
        self.init()
        update(entry: entry, maxLength: maxLength)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(entry: CBElement, maxLength: Int) {
        self.entry = entry
        var menuTitel = entry.string
        menuTitel = menuTitel.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        menuTitel = menuTitel.replacingOccurrences(of: "\n", with: "")
        if menuTitel.count > maxLength {
            let index = menuTitel.index(menuTitel.startIndex, offsetBy: maxLength-1)
            menuTitel = menuTitel[..<index] + "..."
        }
        isEnabled = true
        if entry.isFile {
            isEnabled = false
        }
        title = menuTitel
        toolTip = entry.string
    }
    
    @objc func copyEntry(_ sender: NSMenuItem?) {
   
    }
}
