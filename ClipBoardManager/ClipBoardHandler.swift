//
//  ClipBoardHandler.swift
//  ClipBoardManager
//
//  Created by Lennard on 19.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa

struct CBElement {
    var string :String
    var isFile :Bool
    var content :[NSPasteboard.PasteboardType : Data]
}

class ClipBoardHandler {
    let clippings = URL(fileURLWithPath: "\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path)/ClipBoardManager/Clippings")
    let clipBoard = NSPasteboard.general
    var oldChangeCount :Int!
    var isWriting = false
    var history :[CBElement]!
    
    init() {
        oldChangeCount = -1
        history = []
    }
    
    func read() -> CBElement {
        if !hasChanged() {
            return history.first ?? CBElement(string: "", isFile: false, content: [:])
        }
        var content :[NSPasteboard.PasteboardType : Data] = [:]
        for t in clipBoard.types ?? [] {
            if let data = clipBoard.data(forType: t) {
                content[t] = data
            }
        }
        history.insert(CBElement(string: clipBoard.string(forType: NSPasteboard.PasteboardType.string) ?? "No Preview Found", isFile: content[NSPasteboard.PasteboardType.URL] != nil, content: content), at: 0)
        return history.first!
    }
    
    func write(entry: CBElement) {
        isWriting = true //TODO: make thread save
        clipBoard.clearContents()
        for (t, d) in entry.content {
            clipBoard.setData(d, forType: t)
        }
        oldChangeCount = clipBoard.changeCount
        isWriting = false
    }
    
    func write(historyIndex: Int) {
        write(entry: history[historyIndex])
    }
        
    func clear() {
        history.removeAll()
        oldChangeCount = -1
    }
    
    func hasChanged() -> Bool {
        if !isWriting && oldChangeCount != clipBoard.changeCount {
            oldChangeCount = clipBoard.changeCount
            return true
        }
        return false
    }
    
    func logPasetBoard() {
        let logPB = {(name: String, t: NSPasteboard.PasteboardType) in
            print(name)
            print("Type: " + t.rawValue)
            print(self.clipBoard.pasteboardItems![0].propertyList(forType: t))
            print(self.clipBoard.pasteboardItems![0].string(forType: t))
            print(self.clipBoard.pasteboardItems![0].data(forType: t))
        }
        
        print(clipBoard.changeCount)
        print(logPB("pdf", NSPasteboard.PasteboardType.pdf))
        print(logPB("url", NSPasteboard.PasteboardType.URL))
        print(logPB("string", NSPasteboard.PasteboardType.string))
        print(logPB("fileContents", NSPasteboard.PasteboardType.fileContents))
        print(logPB("fileURL", NSPasteboard.PasteboardType.fileURL))
        print(logPB("findPanelSearchOptions", NSPasteboard.PasteboardType.findPanelSearchOptions))
        print(logPB("html", NSPasteboard.PasteboardType.html))
        print(logPB("multipleTextSelection", NSPasteboard.PasteboardType.multipleTextSelection))
        print(logPB("png", NSPasteboard.PasteboardType.png))
        print(logPB("rtf", NSPasteboard.PasteboardType.rtf))
        print(logPB("rtfd", NSPasteboard.PasteboardType.rtfd))
        print(logPB("ruler", NSPasteboard.PasteboardType.ruler))
        print(logPB("sound", NSPasteboard.PasteboardType.sound))
        print(logPB("tabularText", NSPasteboard.PasteboardType.tabularText))
        print(logPB("textFinderOptions", NSPasteboard.PasteboardType.textFinderOptions))
        print(logPB("tiff", NSPasteboard.PasteboardType.tiff))
        print(logPB("color", NSPasteboard.PasteboardType.color))
        print(logPB("font", NSPasteboard.PasteboardType.font))
    }
}
