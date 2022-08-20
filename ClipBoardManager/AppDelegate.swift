//
//  AppDelegate.swift
//  ClipBoardManager
//
//  Created by Lennard Kittner on 14.08.18.
//  Copyright © 2018 Lennard Kittner. All rights reserved.
//

import Cocoa
//import LaunchAtLogin

//TODO: Test config
//TODO: save clippings
//TODO: add autostart
//TODO: make universall
//TODO: migrate to swiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var preferencesController :NSWindowController?
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var configHandler :ConfigHandler!
    var clipBoardHandler :ClipBoardHandler!
    var menuDelegate :NSMenuDelegate?
    var timer :Timer?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("icon"))
        }
        
        clipBoardHandler = ClipBoardHandler()
        configHandler = ConfigHandler(onChange: applyCfg)
        statusItem.menu = MainMenu(configHandler: configHandler, clipBoardHandler: clipBoardHandler)
        menuDelegate = OnOpenMenuDelegate(onOpen: refrshMenu)
        statusItem.menu?.delegate = menuDelegate
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func refrshMenu(menu: NSMenu) {
        if let mainMenu = menu as? MainMenu {
            mainMenu.refrsh(clipBoardHistory: clipBoardHandler.history)
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
        
    func startTimer(wait: Double){
        timer = Timer.scheduledTimer(timeInterval: wait, target: self, selector: #selector(refreshClipBoard(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func refreshClipBoard(_ sender: Any?) {
        clipBoardHandler.read()
    }
    
    @objc func setStartAtLogin() {
        //LaunchAtLogin.isEnabled = startAtLogin
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
}

extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}
