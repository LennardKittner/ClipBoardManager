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
    }
    
    required init(coder: NSCoder) {
        configHandler = ConfigHandler(onChange: {(c) in })
        super.init(coder: coder)
    }
    
    func refrsh(clipBoardHistory :[CBElement]) {
        var cph = clipBoardHistory
        removeAllItems()
        var max_width :CGFloat = 120
        
        for (i, item) in clipBoardHistory.enumerated() {
            var tmp = item.string
            if item.string.count > configHandler.conf.previewWidth {
                let index = item.string.index(item.string.startIndex, offsetBy: configHandler.conf.previewWidth-1)
                tmp = item.string[..<index] + "..."
            }
            let color :NSColor = (UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light").contains("ark") ? NSColor.white : NSColor.black
            let attributs = [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : NSFont.menuBarFont(ofSize: (NSFont.systemFontSize+2))];
            cph[i].itemTitle = NSAttributedString(string: tmp, attributes: attributs)
            if max_width < clipBoardHistory[i].itemTitle?.size().width ?? 0 {
                max_width = (clipBoardHistory[i].itemTitle?.size().width)!
            }
        }
        
        var i = 0
        for element in cph {
            var item :NSMenuItem
            item = NSMenuItem(title: "", action:  #selector(AppDelegate.copy(_:)), keyEquivalent: String(i))
            item.toolTip = element.string
            item.tag = i
            item.view = MenuItemEvent(frame: NSRect(x: 0, y: 0, width: 300, height: 20), title: element.itemTitle!, prefix: element.prefix, width: max_width, tag: i)
            addItem(item)
            
            i = i + 1
            if i == configHandler.conf.clippingCount {
                break
            }
        }
        
        if cph.isEmpty {
            let placeholder = NSMenuItem(title: "Your clippings will apear here...", action: nil, keyEquivalent: "")
            placeholder.isEnabled = false
            addItem(placeholder)
        }
        
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Clear", action: #selector(AppDelegate.clear(_:)), keyEquivalent: "l"))
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPreferences(_:)), keyEquivalent: ","))
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
}
