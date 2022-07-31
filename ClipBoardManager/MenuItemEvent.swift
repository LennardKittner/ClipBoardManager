//
//  MenuItemEvent.swift
//  ClipBoardManager
//
//  Created by Lennard Kittner on 12.09.18.
//  Copyright © 2018 Lennard Kittner. All rights reserved.
//

import Cocoa

class MenuItemEvent: NSView {
    let titleV = Subview()
    var title :NSAttributedString!
    let prefixV = Subview()
    var prefix :NSAttributedString!
    let keyEquivalentV = Subview()
    var keyEquivalent :NSAttributedString!
    var background :Subview!
    var highlighted = false
    var _tag = -1
    override var tag: Int {
        get {
            return _tag
        }
        set {
            _tag = newValue
        }
    }
    var title_highlight :NSAttributedString!
    var keyEquivalent_highlight :NSAttributedString!
    var prefix_highlight :NSAttributedString!
    var mode_dark = true
    
    init(frame frameRect: NSRect, title: NSAttributedString, prefix: String, width: CGFloat, tag: Int) {
        let keyEquivalentT = "⌘\(tag == 0 ? "0" : String(tag))"

        var color :NSColor = NSColor.white
            if (UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light").contains("ight") {
                color = NSColor.black
                mode_dark = false
                
                title_highlight = NSAttributedString(string: title.string, attributes: [NSAttributedStringKey.foregroundColor : NSColor.white, NSAttributedStringKey.font : NSFont.menuBarFont(ofSize: (NSFont.systemFontSize+2))])
                keyEquivalent_highlight = NSAttributedString(string: keyEquivalentT, attributes: [NSAttributedStringKey.foregroundColor : NSColor.white, NSAttributedStringKey.font : NSFont.menuBarFont(ofSize: (NSFont.systemFontSize+1))])
                prefix_highlight = NSAttributedString(string: prefix, attributes: [NSAttributedStringKey.foregroundColor : NSColor.white, NSAttributedStringKey.font : NSFont.menuBarFont(ofSize: (NSFont.systemFontSize-2))])
            }

        let attributsP = [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : NSFont.menuBarFont(ofSize: (NSFont.systemFontSize-2))];
        
        let attributsK = [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : NSFont.menuBarFont(ofSize: (NSFont.systemFontSize+1))];
        
        let size_title = width
       
        let frame = NSRect(x: frameRect.minX, y: frameRect.minY, width: (21+35+size_title+10), height: frameRect.height)
        super.init(frame: frame)
        background = Subview(frame: frame)

        self.tag = tag
        
        titleV.frame = NSRect(x: 21, y: 0, width: size_title, height: 20)
        self.title = title
        
        prefixV.frame = NSRect(x: 2, y: -4, width: 19, height: 20)
        self.prefix = NSAttributedString(string: prefix, attributes: attributsP)
        
        keyEquivalentV.frame = NSRect(x: 21+size_title+12, y: 0, width: 35, height: 20)
        self.keyEquivalent = tag > 9 ? NSAttributedString(string: "") : NSAttributedString(string: keyEquivalentT, attributes: attributsK)
        
        self.addTrackingArea(NSTrackingArea(rect: self.bounds, options: [NSTrackingArea.Options.activeInKeyWindow, NSTrackingArea.Options.mouseEnteredAndExited], owner: self, userInfo: nil))
        
        self.wantsLayer = true
        self.addSubview(background)
        self.addSubview(titleV)
        self.addSubview(prefixV)
        self.addSubview(keyEquivalentV)
        title.draw(in: titleV.frame)
        prefix.draw(in: prefixV.frame)
        keyEquivalent.draw(in: keyEquivalentV.frame)
        self.layer?.backgroundColor = CGColor.clear
    }
    
    func accent_color() -> NSColor {
        if #available(OSX 10.14, *) {
            return NSColor.controlAccentColor
        } else {
            return NSColor.selectedMenuItemColor
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        highlighted = false
        self.draw(self.bounds)
    }
    
    override func mouseEntered(with event: NSEvent) {
        highlighted = true
        self.draw(self.bounds)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        print("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if highlighted {
            //self.layer?.backgroundColor = NSColor.selectedMenuItemColor.cgColor
            if  mode_dark {
                title.draw(in: titleV.frame)
                prefix.draw(in: prefixV.frame)
                keyEquivalent.draw(in: keyEquivalentV.frame)
                self.setNeedsDisplay(self.bounds)
            } else {
                title_highlight.draw(in: titleV.frame)
                prefix_highlight.draw(in: prefixV.frame)
                keyEquivalent_highlight.draw(in: keyEquivalentV.frame)
                self.setNeedsDisplay(self.bounds)
            }
            self.layer?.backgroundColor = accent_color().cgColor
        }
        else {
            title.draw(in: titleV.frame)
            prefix.draw(in: prefixV.frame)
            keyEquivalent.draw(in: keyEquivalentV.frame)
            self.setNeedsDisplay(self.bounds)
            self.layer?.backgroundColor = CGColor.clear
        }
    }
    
    override func rightMouseUp(with event: NSEvent) {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        delegate.deleteFromList(index: (self.enclosingMenuItem?.tag)!)
        self.enclosingMenuItem?.menu?.removeItem(self.enclosingMenuItem!)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.enclosingMenuItem?.menu?.cancelTracking()
        (NSApplication.shared.delegate as! AppDelegate).copy(tag: tag)
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
        
    override func keyUp(with event: NSEvent) {
        print(event.keyCode)
        print(event.modifierFlags)
    }
}

class Subview: NSView {
    override func mouseUp(with event: NSEvent) {
        self.enclosingMenuItem?.menu?.cancelTracking()
        (NSApplication.shared.delegate as! AppDelegate).copy(tag: (superview?.tag)!)
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
}
