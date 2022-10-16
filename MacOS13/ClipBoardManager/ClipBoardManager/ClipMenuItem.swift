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
    private var image :Image
    
    init(clip: CBElement, maxLength: Int) {
        self.clip = clip
        self.maxLength = maxLength
        if clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.isFile {
            image = Image(systemName: "doc.fill")
        } else if clip.isFile {
            let nsImage = NSImage(data: clip.content[NSPasteboard.PasteboardType("com.apple.icns")] ?? Data()) ?? NSImage()
            nsImage.size = NSSize(width: 15, height: 15)
            image = Image(nsImage: nsImage)
        } else {
            let nsImage = NSImage()
            nsImage.size = NSSize(width: 15, height: 15)
            image = Image(nsImage: nsImage)
        }
    }
    
    var body: some View {
        Button(action: {
            clipBoardHandler.write(entry: clip)
        }) {
            Text(calcTitel(clip: clip, maxLength: maxLength))
            image
                .resizable()
                .frame(width: 15, height: 15)
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
        return menuTitel
    }
}

struct ClipMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        ClipMenuItem(clip: CBElement(), maxLength: 40)
            .environmentObject(ClipBoardHandler(configHandler: ConfigHandler()))
    }
}
