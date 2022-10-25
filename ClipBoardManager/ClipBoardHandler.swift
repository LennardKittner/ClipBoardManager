//
//  ClipBoardHandler.swift
//  ClipBoardManager
//
//  Created by Lennard on 19.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa

class ClipBoardHandler {
    let clipBoard = NSPasteboard.general
    var excludedTypes = ["com.apple.finder.noderef"]
    var oldChangeCount :Int!
    var accessLock :NSLock
    var history :[CBElement]!
    private var _historyCapacity :Int
    var historyCapacity :Int {
        get { return _historyCapacity }
        set {
            _historyCapacity = newValue
            if history.count > _historyCapacity {
                history.removeLast(history.count - _historyCapacity)
            }
        }
    }
    
    init(historyCapacity: Int) {
        self._historyCapacity = historyCapacity
        oldChangeCount = clipBoard.changeCount
        history = []
        accessLock = NSLock()
    }
    
    func read() -> CBElement {
        accessLock.lock()
        if !hasChanged() {
            accessLock.unlock()
            return history.first ?? CBElement(string: "", isFile: false, content: [:])
        }
        var content :[NSPasteboard.PasteboardType : Data] = [:]
        for t in clipBoard.types ?? [] {
            if !excludedTypes.contains(t.rawValue) {
                if let data = clipBoard.data(forType: t) {
                    content[t] = data
                }
            }
        }
        history.insert(CBElement(string: clipBoard.string(forType: NSPasteboard.PasteboardType.string) ?? "No Preview Found", isFile: content[NSPasteboard.PasteboardType.URL] != nil, content: content), at: 0)
        if history.count > historyCapacity {
            history.removeLast(history.count - historyCapacity)
        }
        accessLock.unlock()
        return history.first!
    }
    
    func write(entry: CBElement) {
        accessLock.lock()
        clipBoard.clearContents()
        for (t, d) in entry.content {
            clipBoard.setData(d, forType: t)
        }
        oldChangeCount = clipBoard.changeCount
        accessLock.unlock()
    }
    
    func write(historyIndex: Int) {
        write(entry: history[historyIndex])
    }
        
    func clear() {
        history.removeAll()
    }
    
    func hasChanged() -> Bool {
        if oldChangeCount != clipBoard.changeCount {
            oldChangeCount = clipBoard.changeCount
            return true
        }
        return false
    }
    
    func getHistoryAsJSON() -> String {
        let hs = history.map({(e) in e.toMap()})
        if let jsonData = try? JSONSerialization.data(withJSONObject: hs, options: .prettyPrinted) {
            return String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        }
        return ""
    }

    func loadHistoryFromJSON(JSON: String) {
        let decoded = try? JSONSerialization.jsonObject(with: JSON.data(using: String.Encoding.utf8) ?? Data(), options: [])
        if let arr = decoded as? [[String : String]] {
            for dict in arr {
                self.history.append(CBElement(from: dict))
            }
        }
    }
    
    func logPasetBoard() {
        let logPB = {(name: String, t: NSPasteboard.PasteboardType) in
            print(name)
            print("Type: " + t.rawValue)
            print(self.clipBoard.pasteboardItems?[0].propertyList(forType: t) ?? "")
            print(self.clipBoard.pasteboardItems?[0].string(forType: t) ?? "")
            print(self.clipBoard.pasteboardItems?[0].data(forType: t) ?? "")
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
