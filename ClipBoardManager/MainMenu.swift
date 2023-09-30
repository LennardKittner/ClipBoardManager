//
//  MainMenu.swift
//  ClipBoardManager
//
//  Created by Lennard on 20.10.22.
//

import SwiftUI

struct MainMenu: View {
    @EnvironmentObject var clipBoardHandler: ClipBoardHandler
    @EnvironmentObject var configHandler :ConfigHandler
    @State private var curretnTab = 0
    
    var body: some View {
        //TODO: this always recreates all ClipMenuItem when the history changes, which is not ideal.
        ForEach(clipBoardHandler.history.indices, id: \.self) { id in
            ClipMenuItem(clip: CBElement(string: clipBoardHandler.history[id].string, isFile: clipBoardHandler.history[id].isFile, content: clipBoardHandler.history[id].content), maxLength: configHandler.conf.previewLength)
        }
        Divider()
        Button("Clear") {
            clipBoardHandler.clear()
        }.keyboardShortcut("l")
        Divider()
        Button("Preferences") {
            TabView(currentTab: $curretnTab)
                .environmentObject(configHandler)
                .openNewWindowWithToolbar(title: "ClipBoardManager", rect: NSRect(x: 0, y: 0, width: 450, height: 150), style: [.closable, .titled],identifier: "Settings", toolbar: Toolbar(tabs: ["About", "Settings"], currentTab: $curretnTab))
        }.keyboardShortcut(",")
        Divider()
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }.keyboardShortcut("q")
    }
}


struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
            .environmentObject(ConfigHandler())
            .environmentObject(ClipBoardHandler(configHandler: ConfigHandler()))
    }
}
