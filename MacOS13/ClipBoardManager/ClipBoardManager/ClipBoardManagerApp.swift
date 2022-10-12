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
    
    var body: some Scene {
        WindowGroup("") {
            Text("placeholder")
        }
        .commands {
            CommandMenu("My Top Menu") {
                ClipMenuItem()
                Divider()
                Button("Clear") {
                    print("clear")
                }
                Divider()
                Button("Preferences") {
                    OpenWindows.Settings.open()
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
