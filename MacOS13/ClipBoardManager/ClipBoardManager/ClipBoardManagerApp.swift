//
//  ClipBoardManagerApp.swift
//  ClipBoardManager
//
//  Created by Lennard on 12.10.22.
//

import SwiftUI

@main
struct ClipBoardManagerApp: App {
    @StateObject private var configHandler = ConfigHandler()
    @StateObject private var clipBoardHandler = ClipBoardHandler(historyCapacity: 10)
    
    var body: some Scene {
        WindowGroup("") {
            Text("placeholder")
        }
        .commands {
            CommandMenu("My Top Menu") {
                ForEach(clipBoardHandler.history.indices) { id in
                    ClipMenuItem(clip: CBElement(string: clipBoardHandler.history[id].string, isFile: clipBoardHandler.history[id].isFile, content: clipBoardHandler.history[id].content), maxLength: 40)
                        .environmentObject(clipBoardHandler)
                }
                Divider()
                Button("Clear") {
                    print("clear")
                    NSApplication.shared.mainWindow!.toolbarStyle = .preference
                }
                Divider()
                Button("Preferences") {
                    ToolBarView()
                        .environmentObject(configHandler)
                        .openNewWindow()
//                    NSApplication.shared.mainWindow?.close()
//                    OpenWindows.Settings.open()
                }
                Divider()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        
        WindowGroup("") {
            ToolBarView()
                .environmentObject(configHandler)
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
