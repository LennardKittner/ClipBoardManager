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
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var preferencesController :NSWindowController?
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let clipBoard = NSPasteboard.general
    var configHandler :ConfigHandler!
    var menuDelegate :NSMenuDelegate?
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
    
    let clippings = URL(fileURLWithPath: "\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path)/ClipBoardManager/Clippings")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        startTimer(wait: refreshTime)
        changeOld = clipBoard.changeCount

        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
        }
        
        setStartAtLogin()
        
        configHandler = ConfigHandler(onChange: applyCfg)
        statusItem.menu = MainMenu(configHandler: configHandler)
        menuDelegate = OnOpenMenuDelegate(onOpen: refrshMenu)
        statusItem.menu?.delegate = menuDelegate
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func refrshMenu(menu: NSMenu) {
        if let mainMenu = menu as? MainMenu {
            mainMenu.refrsh(clipBoardHistory: list)
        }
    }
    
    func applyCfg(conf :ConfigData) {
        configHandler?.writeCfg()
        if conf.startAtLogin {
            setStartAtLogin()
        }
        if timer?.timeInterval ?? -1 != conf.refreshTime {
            timer?.invalidate()
            startTimer(wait: conf.refreshTime)
        }
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
//            let fileURL_t = NSURL(from: clipBoard)
//            if fileURL_t != nil {
//                var prefix = ""
//                if !(fileURL_t?.hasDirectoryPath)! {
//                    let file_extension = fileURL_t?.pathExtension?.uppercased()
//                    for i in 0...9 {
//                        if file_types[i].contains(file_extension!) {
//                            prefix = file_icons[i][Int(arc4random_uniform(UInt32(file_icons[i].count)))]
//                            break
//                        }
//                    }
//                    if prefix.isEmpty {
//                        prefix = text_file_icons[0]
//                    }
//                }
//                else {
//                    prefix = folder_file_icons
//                }
//                list.insert(CBElement(string: fileURL_t!.path!, isFile: true, prefix: prefix, itemTitle: nil), at: 0)
//            }
//            else {
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
    
    @objc func clear(_ sender: NSMenuItem?) {
        list.removeAll()
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
    
}

struct CBElement {
    var string :String
    let isFile :Bool
    let prefix :String
    var itemTitle :NSAttributedString?
}
