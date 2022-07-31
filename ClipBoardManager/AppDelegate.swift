//
//  AppDelegate.swift
//  ClipBoardManager
//
//  Created by Lennard Kittner on 14.08.18.
//  Copyright © 2018 Lennard Kittner. All rights reserved.
//

import Cocoa
//import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    var preferencesController :NSWindowController?
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let clipBoard = NSPasteboard.general
    var timer :Timer?
    var changeOld :Int = 0
    var list :[CBElement] = []
    var removed :[Int : CBElement] = [:]
    var removed_index :[Int] = []
    var copy_return = false
    var copy_space = false
    var max_display = 20
    var startAtLogin = false
    var refreshTime :Double = 0.5
    var preview_length = 40
    static var m = NSMenu()
    
    let clippings = URL(fileURLWithPath: "\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path)/ClipBoardManager/Clippings")
    let conf_file = URL(fileURLWithPath: "\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path)/ClipBoardManager/ClipBoardManager.cfg")
    
    let image_file_icons = ["🗾", "🎑", "🏞", "🌅", "🌄", "🌠", "🎇", "🎆", "🌇", "🌆", "🏙", "🌃", "🌌", "🌉", "🌁"]
    let image_file_extension = ["BMP", "DDS", "GIF", "JPG", "JPEG", "PNG", "PSD", "PSPIMAGE", "TGA", "THM", "TIF", "TIFF", "YUV", "AI", "EPS", "PS", "SVG"]
    
    let video_file_icons = ["🎥"]
    let video_file_extension = ["3G2", "3GP", "ASF", "AVI", "FLV", "M4V", "MOV", "MP4", "MPG", "RM", "SRT", "SWF", "VOB", "WMV"]
    
    let sound_file_icons = ["🎵", "🎶"]
    let sound_file_extension = ["AIF", "IFF", "M3U", "M4A", "MID", "MP3", "MPA", "WAV", "WMA"]
    
    let text_file_icons = ["📃", "📄"]
    let text_file_extension = ["DOC", "DOCX", "LOG", "MSG", "CDT", "PAGES", "RTF", "TEX", "TXT", "WPD", "WPS"]
    
    let folder_file_icons = "📁"

    let code_file_icons = ["📜"]
    let code_file_extension = ["ASP", "ASPX", "CSS", "SCSS", "SASS", "LESS", "HTM", "HTML", "JS", "JSX", "TS", "TSX", "JSP", "PHP", "XHTML", "CRX", "PLUGIN", "DLL", "C", "CLASS", "CPP", "CS", "DTD", "H", "JAVA", "LUA", "M", "GO", "PL", "PY", "SH", "ZSH", "SLN", "SWIFT", "R", "FS", "VCXPROJ", "XCODEPROJ", "MD", "JSON", "CSON", "YAML", "CONF", "MJS"]
    
    let database_file_icons = ["💾"]
    let database_file_extension = ["ACCDB", "DB", "DBF", "MDB", "PDB", "SQL", "SQLITE"]

    let spreadsheet_file_icons = ["📊"]
    let spreadsheet_file_extension = ["XLR", "XLS", "XLSX"]
    
    let executable_file_icons = ["💻", "🖥"]
    let executable_file_extension = ["APK", "APP", "BAT", "CGI", "COM", "EXE", "GADGET", "JAR", "WSF"]
    
    let compressed_file_icons = ["📦"]
    let compressed_file_extension = ["7Z", "CBR", "GZ", "PKG", "RAR", "RPM", "SITX", "TAR", "GZ", "TAR.GZ", "ZIP", "ZIPX"]
    
    let diskImg_file_icons = ["💽"]
    let diskImg_file_extension = ["BIN", "CUE", "DMG", "ISO", "MDF", "TOAST", "VCD"]
    
    var file_types :[[String]] = []
    var file_icons :[[String]] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        file_types = [image_file_extension, video_file_extension, sound_file_extension, text_file_extension, code_file_extension, database_file_extension, spreadsheet_file_extension, executable_file_extension, compressed_file_extension, diskImg_file_extension]
        file_icons = [image_file_icons, video_file_icons, sound_file_icons, text_file_icons, code_file_icons, database_file_icons, spreadsheet_file_icons, executable_file_icons, compressed_file_icons, diskImg_file_icons]

        try! FileManager.default.createDirectory(atPath: (clippings.path), withIntermediateDirectories: true, attributes: nil)
        
        if !FileManager.default.fileExists(atPath: (conf_file.path)) {
            FileManager.default.createFile(atPath: (conf_file.path), contents: ("Display:\(String(max_display))\nAtLogin:\((startAtLogin ? "yes" : "no"))").data(using: String.Encoding.utf8, allowLossyConversion: false)!, attributes: nil)
        }
        else {
            let conf = try!  String.init(contentsOf: conf_file).components(separatedBy: CharacterSet.newlines)
            for c in conf {
                if c.contains("Display:") {
                    max_display = Int(c.components(separatedBy: ":")[1]) ?? 20
                }
                else if c.contains("AtLogin:") {
                    if c.contains("yes") {
                        startAtLogin = true
                    }
                }
                else if c.contains("Refresh:") {
                    refreshTime = Double(c.components(separatedBy: ":")[1]) ?? 0.5
                }
                else if c.contains("Preview:") {
                    preview_length = Int(c.components(separatedBy: ":")[1]) ?? 40
                }
            }
        }
        
        startTimer(wait: refreshTime)
        changeOld = clipBoard.changeCount

        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
        }
        
        setStartAtLogin()
        
        statusItem.menu = NSMenu()
        statusItem.menu?.delegate = self
        refreshMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //is called when the menubar button is clicked
    func menuNeedsUpdate(_ menu: NSMenu) {
        refreshMenu()
    }
    
    static func displayMenu(event: NSEvent, menu: NSMenu, view: NSView) {
       // statusItem.menu!.popUpContextMenu(menu, event, view)
    }
    
    @objc func deleteFromList(index: Int) {
        removed_index.insert(index, at: 0)
        removed[index] = list.remove(at: index)
    }
    
    @objc func startTimer(wait: Double){
        timer = Timer.scheduledTimer(timeInterval: wait, target: self, selector: #selector(refresh(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func setStartAtLogin() {
        //LaunchAtLogin.isEnabled = startAtLogin
    }
    
    @objc func copy(_ sender: NSMenuItem?) {
        copy(tag: (sender?.tag)!)
        print("asdfasdf")
    }

    public func copy(tag: Int) {
        timer?.invalidate()             //the timer is stopped because it would fire before the clean up in this function happens
        clipBoard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        let tmp = list[(tag)]
        if tmp.isFile {
            let apsc = """
            set myFile to \"\(tmp.string)\"
                set the clipboard to POSIX file (myFile)
                end run
            """
            let script = NSAppleScript(source: apsc)
            //var error :NSDictionary?
            //script?.executeAndReturnError(&error)
            script?.executeAndReturnError(nil)
        }
        else {
            clipBoard.setString(tmp.string, forType: NSPasteboard.PasteboardType.string)
        }
        changeOld = clipBoard.changeCount
        startTimer(wait: refreshTime)                //the cleanup is finished so the timer resumes
    }
    
    @objc func refresh(_ sender: Any?) {
        if checkClipBoard() {
            let fileURL_t = NSURL(from: clipBoard)
            if fileURL_t != nil {
                var prefix = ""
                if !(fileURL_t?.hasDirectoryPath)! {
                    let file_extension = fileURL_t?.pathExtension?.uppercased()
                    for i in 0...9 {
                        if file_types[i].contains(file_extension!) {
                            prefix = file_icons[i][Int(arc4random_uniform(UInt32(file_icons[i].count)))]
                            break
                        }
                    }
                    if prefix.isEmpty {
                        prefix = text_file_icons[0]
                    }
                }
                else {
                    prefix = folder_file_icons
                }
                list.insert(CBElement(string: fileURL_t!.path!, isFile: true, prefix: prefix, itemTitle: nil), at: 0)
            }
            else {
                let tmp = clipBoard.pasteboardItems![0].string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) ?? ""
            
                if copy_return {
                    copy_return = false
                    let tmps = tmp.components(separatedBy: CharacterSet.newlines)
                    for t in tmps.reversed() {
                        if !t.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines).isEmpty {
                            list.insert(CBElement(string: t, isFile: false, prefix: "", itemTitle: nil), at: 0)
                        }
                    }
                }
                else if copy_space {
                    copy_space = false
                    let tmps = tmp.components(separatedBy: " ")
                    for t in tmps.reversed() {
                        if !t.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines).isEmpty {
                            list.insert(CBElement(string: t, isFile: false, prefix: "", itemTitle: nil), at: 0)
                        }
                    }
                }
                else {
                    if !tmp.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines).isEmpty {
                        list.insert(CBElement(string: tmp, isFile: false, prefix: "", itemTitle: nil), at: 0)
                    }
                }
            }
        }
    }
    
    @objc func clear(_ sender: NSMenuItem?) {
        print("key")
        list.removeAll()
        refreshMenu()
    }
    
    @objc func undo(_ sender: Any?) {
        list.insert(removed[removed_index.last!]!, at: removed_index.last!)
        removed_index.removeLast()
    }
    
    @objc func copyMode_return(_ sender: Any?) {
        copy_return = copy_return ? false : true
        copy_space = false
        refreshMenu()
    }
    
    @objc func copyMode_space(_ sender: Any?) {
        copy_space = copy_space ? false : true
        copy_return = false
        refreshMenu()
    }
    
    @objc func showPreferences(_ sender: Any?) {
        if (preferencesController == nil) {
            let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Preferences"), bundle: nil)
            preferencesController = storyboard.instantiateInitialController() as? NSWindowController
        }
        
        if (preferencesController != nil) {
            preferencesController!.showWindow(sender)
        }
    }
    
    func checkClipBoard() -> Bool {
        if changeOld != clipBoard.changeCount {
            changeOld = clipBoard.changeCount
            return true
        }
        return false
    }
    
    func refreshMenu() {
        let menu = statusItem.menu!
        menu.removeAllItems()
        var max_width :CGFloat = 120
        
        for (i, item) in list.enumerated() {
            var tmp = item.string
            if item.string.count > preview_length {
                let index = item.string.index(item.string.startIndex, offsetBy: preview_length-1)
                tmp = item.string[..<index] + "..."
            }
            let color :NSColor = (UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light").contains("ark") ? NSColor.white : NSColor.black
            let attributs = [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : NSFont.menuBarFont(ofSize: (NSFont.systemFontSize+2))];
            list[i].itemTitle = NSAttributedString(string: tmp, attributes: attributs)
            if max_width < list[i].itemTitle?.size().width ?? 0 {
                max_width = (list[i].itemTitle?.size().width)!
            }
        }
        
        var i = 0
        for element in list {
            var item :NSMenuItem
            item = NSMenuItem(title: "", action:  #selector(AppDelegate.copy(_:)), keyEquivalent: String(i))
            item.toolTip = element.string
            item.tag = i
            item.view = MenuItemEvent(frame: NSRect(x: 0, y: 0, width: 300, height: 20), title: element.itemTitle!, prefix: element.prefix, width: max_width, tag: i)
            menu.addItem(item)
            
            i = i + 1
            if i == max_display {
                break
            }
        }
        
        if list.isEmpty {
            let placeholder = NSMenuItem(title: "Your clippings will apear here...", action: nil, keyEquivalent: "")
            placeholder.isEnabled = false
            menu.addItem(placeholder)
        }
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Clear", action: #selector(AppDelegate.clear(_:)), keyEquivalent: "l"))
        //menu.addItem(NSMenuItem(title: "Un do Deletion", action: #selector(AppDelegate.undo(_:)), keyEquivalent: "z"))
        let copyMode = NSMenuItem(title: "Copy Modes", action: #selector(AppDelegate.clear(_:)), keyEquivalent: "")
        menu.addItem(copyMode)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showPreferences(_:)), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        let copyModes = NSMenu()
        copyModes.addItem(NSMenuItem(title: "at Return " + (copy_return ? "✔︎" : ""), action:#selector(AppDelegate.copyMode_return(_:)), keyEquivalent: ""))
        copyModes.addItem(NSMenuItem(title: "at Whitespace " + (copy_space ? "✔︎" : ""), action:#selector(AppDelegate.copyMode_space(_:)), keyEquivalent: ""))

        copyMode.submenu = copyModes
        copyMode.toolTip = "chose a copy Mode for your next copy"
        
    }
}

struct CBElement {
    var string :String
    let isFile :Bool
    let prefix :String
    var itemTitle :NSAttributedString?
}
