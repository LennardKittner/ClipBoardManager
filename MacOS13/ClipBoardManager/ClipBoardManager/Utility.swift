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
