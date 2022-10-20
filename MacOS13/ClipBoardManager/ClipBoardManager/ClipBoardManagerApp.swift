//
//  ClipBoardManagerApp.swift
//  ClipBoardManager
//
//  Created by Lennard on 12.10.22.
//

import SwiftUI

var configHandler = ConfigHandler()
var clipBoardHandler = ClipBoardHandler(configHandler: configHandler)

//TODO: autostart
// May not be possible due to menu limitations
//TODO: rightclick to delete
//TODO: Tooltips
@available(macOS 13.0, *)
@main
struct ClipBoardManagerApp: App {
    @StateObject private var _configHandler = configHandler
    @StateObject private var _clipBoardHandler = clipBoardHandler
    @State private var curretnTab = 0
    
    var body: some Scene {
        MenuBarExtra(content: {
            MainMenu()
                .environmentObject(_clipBoardHandler)
                .environmentObject(_configHandler)
        }) {
            Image(systemName: "paperclip")
        }
    }
}
