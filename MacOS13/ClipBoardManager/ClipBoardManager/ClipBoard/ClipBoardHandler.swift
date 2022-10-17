//
//  ClipBoardHandler.swift
//  ClipBoardManager
//
//  Created by Lennard on 19.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa
import Combine

class ClipBoardHandler :ObservableObject {
    private let clippingsPath = URL(fileURLWithPath: "\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path)/ClipBoardManager/Clippings.json")
    private let clipBoard = NSPasteboard.general
    private let configHandler :ConfigHandler
    private var excludedTypes = ["com.apple.finder.noderef"]
    private var extraTypes = [NSPasteboard.PasteboardType("com.apple.icns")]
    private var oldChangeCount :Int!
    private var accessLock :NSLock
    @Published var history :[CBElement]!
    private var timer :Timer!
    private var configSink :Cancellable!
    var historyCapacity :Int
    
    init(configHandler: ConfigHandler) {
        self.configHandler = configHandler
        historyCapacity = configHandler.conf.clippings
        oldChangeCount = clipBoard.changeCount
        history = []
        accessLock = NSLock()
        if let clippings = try? String(contentsOfFile: clippingsPath.path) {
            loadHistoryFromJSON(JSON: clippings)
        }
        NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            let JSON = self.getHistoryAsJSON()
            try? JSON.write(toFile: self.clippingsPath.path, atomically: true, encoding: String.Encoding.utf8)
        }
        configSink = configHandler.$submit.sink(receiveValue: { _ in
            self.historyCapacity = self.configHandler.conf.clippings
            if self.history.count > self.historyCapacity {
                self.history.removeLast(self.history.count - self.historyCapacity)
            }
            
            if self.timer?.timeInterval ?? -1 != TimeInterval(self.configHandler.conf.refreshIntervall) && self.configHandler.conf.refreshIntervall > 0 {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.configHandler.conf.refreshIntervall), target: self, selector: #selector(self.refreshClipBoard(_:)), userInfo: nil, repeats: true)
            }
        })
    }
        
    @objc func refreshClipBoard(_ sender: Any?) {
        read()
    }
    
    func read() -> CBElement {
        accessLock.lock()
        if !hasChanged() {
            accessLock.unlock()
            return history.first ?? CBElement(string: "", isFile: false, content: [:])
        }
        var content :[NSPasteboard.PasteboardType : Data] = [:]
        var types = clipBoard.types
        types?.append(contentsOf: extraTypes)
        for t in types ?? [] {
            if !excludedTypes.contains(t.rawValue) {
                if let data = clipBoard.data(forType: t) {
                    content[t] = data
                }
            }
        }
        let isFile = content[NSPasteboard.PasteboardType.fileURL] != nil || content[NSPasteboard.PasteboardType.tiff] != nil
        let string = clipBoard.string(forType: NSPasteboard.PasteboardType.string)
        // is compression necessary?
        if content[NSPasteboard.PasteboardType.fileURL] != nil && content[NSPasteboard.PasteboardType("com.apple.icns")] == nil {
            var i = 0
            // wait for the icon to be available but atmost 1s
            while clipBoard.data(forType: NSPasteboard.PasteboardType("com.apple.icns")) == nil && i < 200 {
                usleep(5000) // wait 0.005s
                i += 1
            }
        }
        content[NSPasteboard.PasteboardType("com.apple.icns")] = clipBoard.data(forType: NSPasteboard.PasteboardType("com.apple.icns"))
        if content[NSPasteboard.PasteboardType("com.apple.icns")] != nil {
//            var image = Data()
//            if let data = content[NSPasteboard.PasteboardType("com.apple.icns")] {
//                if let image1 = NSImage(data: data) {
//                    if let image2 = image1.resizeImage(tamanho: NSSize(width: 15, height: 15)).tiffRepresentation {
//                        if let image3 = NSBitmapImageRep(data: image2) {
//                            if let image4 = image3.representation(using: .png, properties: [:]) {
//                                image = image4
//                            }
//                        }
//                    }
//                }
//            }
            let image = NSBitmapImageRep(data: NSImage(data: content[NSPasteboard.PasteboardType("com.apple.icns")] ?? Data())?.resizeImage(tamanho: NSSize(width: 15, height: 15)).tiffRepresentation ?? Data())?.representation(using: .png, properties: [:])
            content[NSPasteboard.PasteboardType("com.apple.icns")] = image
        }
        history.insert(CBElement(string: string ?? "No Preview Found", isFile: isFile, content: content), at: 0)
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
        print(logPB("com.apple.icns", NSPasteboard.PasteboardType("com.apple.icns")))
    }
}
