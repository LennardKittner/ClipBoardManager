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
            ToolBarView()
                .environmentObject(configHandler)
        }
        .commands {
            CommandMenu("My Top Menu") {
                Button("Sub Menu Item") { print("You pressed sub menu.") }
            }
        }
    }
}
