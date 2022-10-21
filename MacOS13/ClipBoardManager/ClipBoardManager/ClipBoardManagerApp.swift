//
//  ClipBoardManagerApp.swift
//  ClipBoardManager
//
//  Created by Lennard on 12.10.22.
//

import SwiftUI


//TODO: autostart
// May not be possible due to menu limitations
//TODO: rightclick to delete
//TODO: Tooltips
@available(macOS 13.0, *)
@main
struct ClipBoardManagerApp: App {
    @StateObject private var configHandler :ConfigHandler
    @StateObject private var clipBoardHandler :ClipBoardHandler
    @State private var curretnTab = 0
    
    init() {
        let confH = ConfigHandler()
        self._configHandler = StateObject(wrappedValue: confH)
        self._clipBoardHandler = StateObject(wrappedValue: ClipBoardHandler(configHandler: confH))
    }
    
    var body: some Scene {
        MenuBarExtra(content: {
            MainMenu()
                .environmentObject(configHandler)
                .environmentObject(clipBoardHandler)
        }) {
            Image(systemName: "paperclip")
        }
    }
}
