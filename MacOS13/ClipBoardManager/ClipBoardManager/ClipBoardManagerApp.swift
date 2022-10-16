//
//  ClipBoardManagerApp.swift
//  ClipBoardManager
//
//  Created by Lennard on 12.10.22.
//

import SwiftUI

var configHandler = ConfigHandler()
var clipBoardHandler = ClipBoardHandler(configHandler: configHandler)

//TODO: sometimes icons are not read
@main
struct ClipBoardManagerApp: App {
    @StateObject private var _configHandler = configHandler
    @StateObject private var _clipBoardHandler = clipBoardHandler
    @State private var curretnTab = 0
    
    var body: some Scene {
        WindowGroup("") {
            Text("placeholder")
        }
        .commands {
            CommandMenu("My Top Menu") {
                ForEach(_clipBoardHandler.history.indices) { id in
                    ClipMenuItem(clip: CBElement(string: _clipBoardHandler.history[id].string, isFile: _clipBoardHandler.history[id].isFile, content: _clipBoardHandler.history[id].content), maxLength: _configHandler.conf.previewLength)
                        .environmentObject(_clipBoardHandler)
                }
                Divider()
                Button("Clear") {
                    _clipBoardHandler.clear()
                }.keyboardShortcut("l")
                Divider()
                Button("Preferences") {
                    TabView(currentTab: $curretnTab)
                        .environmentObject(configHandler)
                        .openNewWindowWithToolbar(title: "ClipBoardManager", rect: NSRect(x: 0, y: 0, width: 450, height: 150), style: [.closable, .titled], toolbar: Toolbar(tabs: ["About", "Settings"], currentTab: $curretnTab))
                }.keyboardShortcut(",")
                Divider()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }.keyboardShortcut("q")
            }
        }
    }
}
