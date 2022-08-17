//
//  MainMenu.swift
//  ClipBoardManager
//
//  Created by Lennard on 16.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa

class MainMenu: NSMenu {
    
    let configHandler :ConfigHandler
    
    init(configHandler :ConfigHandler) {
        self.configHandler = configHandler
        super.init(title: "mainMenu")
        autoenablesItems = false
        
        let items = Array(count: configHandler.conf.clippingCount, elementCreator: ClipItem())
        items.forEach({item in item.isHidden = true})
        items.forEach({item in addItem(item)})

        let placeholder = NSMenuItem(title: "Your clippings will apear here...", action: nil, keyEquivalent: "")
        placeholder.isEnabled = false
        addItem(placeholder)
        
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Clear", action: #selector(AppDelegate.clear(_:)), keyEquivalent: "l"))
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPreferences(_:)), keyEquivalent: ","))
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
    
    required init(coder: NSCoder) {
        configHandler = ConfigHandler(onChange: {(c) in })
        super.init(coder: coder)
    }
    
    func refrsh(clipBoardHistory :[CBElement]) {
        for i in 0..<min(configHandler.conf.clippingCount, clipBoardHistory.count) {
            let entry = clipBoardHistory[i]
            if let item = items[i] as? ClipItem {
                item.update(entry: entry, maxLength: configHandler.conf.previewWidth)
                item.isHidden = false
            }
        }
        if (clipBoardHistory.count < configHandler.conf.clippingCount) {
            for i in clipBoardHistory.count..<configHandler.conf.clippingCount {
                items[i].isHidden = true
            }
        }
        items[configHandler.conf.clippingCount].isHidden = !clipBoardHistory.isEmpty
    }
}
