//
//  ClipBoardManagerApp.swift
//  ClipBoardManager
//
//  Created by Lennard on 12.10.22.
//

import SwiftUI

var configHandler = ConfigHandler()
var clipBoardHandler = ClipBoardHandler(configHandler: configHandler)

@main
struct ClipBoardManagerApp: App {
    @StateObject private var _configHandler = configHandler
    @StateObject private var _clipBoardHandler = clipBoardHandler
        
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
                    //NSApplication.shared.mainWindow!.toolbarStyle = .preference
                }.keyboardShortcut("l")
                Divider()
                Button("Preferences") {
//                    ToolBarView()
//                        .environmentObject(configHandler)
//                        .openNewWindow()
                    NSApplication.shared.mainWindow?.close()
                    OpenWindows.Settings.open()
                }.keyboardShortcut(",")
                Divider()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }.keyboardShortcut("q")
            }
        }
        
        WindowGroup("") {
            ToolBarView()
                .environmentObject(_configHandler)
        }.handlesExternalEvents(matching: Set(arrayLiteral: "Settings"))
    }
}

enum OpenWindows: String, CaseIterable {
    case Settings = "Settings"

    func open() {
        if let url = URL(string: "ClipBoardManager://\(self.rawValue)") {
            NSWorkspace.shared.open(url)
        }
    }
}
