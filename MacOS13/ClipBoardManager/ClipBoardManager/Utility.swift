//
//  Utility.swift
//  ClipBoardManager
//
//  Created by Lennard on 12.10.22.
//

import SwiftUI

extension View {
    private func newWindowInternal(title: String, rect: NSRect, style: NSWindow.StyleMask) -> NSWindow {
        let window = NSWindow(
            contentRect: rect,
            styleMask: style,
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        window.toolbarStyle = NSWindow.ToolbarStyle.preference
        let accessoryHostingView = NSHostingView(rootView: ToolBarView())
        accessoryHostingView.frame.size = accessoryHostingView.fittingSize

        let titlebarAccessory = NSTitlebarAccessoryViewController()
        titlebarAccessory.view = accessoryHostingView

        window.addTitlebarAccessoryViewController(titlebarAccessory)

        return window
    }
    
    func openNewWindow(title: String = "new Window", rect: NSRect = NSRect(x: 20, y: 20, width: 680, height: 600), style: NSWindow.StyleMask = [.titled, .closable]) {
        self.newWindowInternal(title: title, rect: rect, style: style).contentView = NSHostingView(rootView: self)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension NSImage {
    func resizeImage(tamanho: NSSize) -> NSImage {

        var ratio: Float = 0.0
        let imageWidth = Float(self.size.width)
        let imageHeight = Float(self.size.height)
        let maxWidth = Float(tamanho.width)
        let maxHeight = Float(tamanho.height)

        // Get ratio (landscape or portrait)
        if (imageWidth > imageHeight) {
            // Landscape
            ratio = maxWidth / imageWidth;
        }
        else {
            // Portrait
            ratio = maxHeight / imageHeight;
        }

        // Calculate new size based on the ratio
        let newWidth = imageWidth * ratio
        let newHeight = imageHeight * ratio

        let imageSo = CGImageSourceCreateWithData(self.tiffRepresentation! as CFData, nil)
        let options: [NSString: NSObject] = [
            kCGImageSourceThumbnailMaxPixelSize: max(imageWidth, imageHeight) * ratio as NSObject,
            kCGImageSourceCreateThumbnailFromImageAlways: true as NSObject
        ]
        let size1 = NSSize(width: Int(newWidth), height: Int(newHeight))
        let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSo!, 0, options as CFDictionary).flatMap {
            NSImage(cgImage: $0, size: size1)
        }

        return scaledImage!
    }

}
