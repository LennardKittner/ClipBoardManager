//
//  ClipMenuItem.swift
//  ClipBoardManager
//
//  Created by Lennard on 12.10.22.
//

import SwiftUI

struct ClipMenuItem: View {
    @EnvironmentObject private var clipBoardHandler :ClipBoardHandler
    var clip :CBElement
    var maxLength :Int
    
    var body: some View {
        Button(calcTitel(clip: clip, maxLength: maxLength)) {
            clipBoardHandler.write(entry: clip)
        }
        .help(clip.string)
    }
    
    private func calcTitel(clip: CBElement, maxLength: Int) -> String {
        var menuTitel = clip.string
        menuTitel = menuTitel.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        menuTitel = menuTitel.replacingOccurrences(of: "\n", with: "")
        if menuTitel.count > maxLength {
            let index = menuTitel.index(menuTitel.startIndex, offsetBy: maxLength-1)
            menuTitel = menuTitel[..<index] + "..."
        }
        if clip.isFile {
            
        }
        return menuTitel
    }
}

struct ClipMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        ClipMenuItem(clip: CBElement(), maxLength: 40)
            .environmentObject(ClipBoardHandler(historyCapacity: 1))
    }
}
