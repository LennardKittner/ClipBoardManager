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
    var preview: String
    var img: Image
    
    init(clip: CBElement, maxLength: Int) {
        self.clip = clip
        self.maxLength = maxLength
        self.preview = ClipMenuItem.calcTitel(clip: clip, maxLength: maxLength)
        self.img = ClipMenuItem.calcImage(clip: clip)
    }
    
    var body: some View {
        Button(action: {
            clipBoardHandler.write(entry: clip)
        }) {
            HStack {
                img
                    .resizable()
                    .frame(width: 15, height: 15)
                Text(preview)
                    //.font(.monospaced(.body)())
                // Does not work :/
//                Text(clip.string)
//                    .lineLimit(1)
//                    .truncationMode(.tail)
//                    .frame(width: 30)
            }
        }
        // Does not work :/
//        .onHover(perform: {bool in
//            print(bool)
//        })
//        .help(clip.string)
    }
    
    private static func calcImage(clip: CBElement) -> Image {
        if clip.isFile && clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.content[NSPasteboard.PasteboardType.tiff] == nil {
            return Image(systemName: "doc.fill")
        }
        var nsImage = NSImage()
        if let image = clip.content[NSPasteboard.PasteboardType.tiff] {
            nsImage = NSImage(data: image) ?? NSImage()
        } else {
            nsImage = NSImage(data: clip.content[NSPasteboard.PasteboardType("com.apple.icns")] ?? Data()) ?? NSImage()
        }
        nsImage.size = NSSize(width: 15, height: 15)
        return Image(nsImage: nsImage)
    }
    
    private static func calcTitel(clip: CBElement, maxLength: Int) -> String {
        var menuTitel = clip.string
        let maxLengthFloat = CGFloat(maxLength)
        menuTitel = menuTitel.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        menuTitel = menuTitel.replacingOccurrences(of: "\n", with: "•")
        let pipe = "|"
        let systemFontSize = NSFont.systemFontSize
        let systemFont = NSFont.systemFont(ofSize: systemFontSize)
        let attributes = [NSAttributedString.Key.font : systemFont]
        let pipeAttrString = NSAttributedString(string: pipe, attributes: attributes)
        let minCharWidth = pipeAttrString.size().width
        let estimatedLength = Int(maxLengthFloat / minCharWidth) + 1
        menuTitel = String(menuTitel.prefix(estimatedLength))
        var attrString = NSAttributedString(string: menuTitel, attributes: attributes)
        var width = attrString.size().width
        let addDots = width > maxLengthFloat
        
        while width > maxLengthFloat && !menuTitel.isEmpty {
            menuTitel = String(menuTitel.dropLast())
            attrString = NSAttributedString(string: menuTitel, attributes: attributes)
            width = attrString.size().width
        }
        
        if addDots {
            menuTitel.append("...")
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

// if clip.isFile && clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.content[NSPasteboard.PasteboardType.tiff] == nil {if clip.isFile && clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.content[NSPasteboard.PasteboardType.tiff] == nil {if clip.isFile && clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.content[NSPasteboard.PasteboardType.tiff] == nil {if clip.isFile && clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.content[NSPasteboard.PasteboardType.tiff] == nil {if clip.isFile && clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.content[NSPasteboard.PasteboardType.tiff] == nil {if clip.isFile && clip.content[NSPasteboard.PasteboardType("com.apple.icns")] == nil && clip.content[NSPasteboard.PasteboardType.tiff] == nil {
