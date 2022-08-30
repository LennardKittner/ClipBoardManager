//
//  MainMenu.swift
//  ClipBoardManager
//
//  Created by Lennard on 16.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa

class MainMenu: NSMenu {
    
    let clipBoardHandler :ClipBoardHandler
    let clippingCount :Int
    let width :Int
    
    init(clipBoardHandler :ClipBoardHandler, clippingCount :Int, width :Int) {
        self.clipBoardHandler = clipBoardHandler
        self.clippingCount = clippingCount
        self.width = width
        super.init(title: "mainMenu")
        autoenablesItems = false
        
        let items = Array(count: clippingCount, elementCreator: ClipItem(clipBoardHandler: clipBoardHandler))
        for i in 0..<items.count {
            items[i].isHidden = true
            items[i].tag = i
            addItem(items[i])
        }

        let placeholder = NSMenuItem(title: "Your clippings will apear here...", action: nil, keyEquivalent: "")
        placeholder.isEnabled = false
        addItem(placeholder)
        
        addItem(NSMenuItem.separator())
        let clear = NSMenuItem(title: "Clear", action: #selector(MainMenu.clear(_:)), keyEquivalent: "l")
        clear.target = self
        addItem(clear)
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPreferences(_:)), keyEquivalent: ","))
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
    
    required init(coder: NSCoder) {
        width = 40
        clippingCount = 10
        clipBoardHandler = ClipBoardHandler(historyCapacity: 10)
        super.init(coder: coder)
    }
    
    func refrsh(clipBoardHistory :[CBElement]) {
        for i in 0..<min(clippingCount, clipBoardHistory.count) {
            let entry = clipBoardHistory[i]
            if let item = items[i] as? ClipItem {
                item.update(entry: entry, maxLength: width)
                item.isHidden = false
            }
        }
        if (clipBoardHistory.count < clippingCount) {
            for i in clipBoardHistory.count..<clippingCount {
                items[i].isHidden = true
            }
        }
        items[clippingCount].isHidden = !clipBoardHistory.isEmpty
    }
    
    @objc func clear(_ sender :Any) {
        clipBoardHandler.clear()
    }
}
