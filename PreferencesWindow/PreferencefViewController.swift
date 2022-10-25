//
//  PreferencefViewController.swift
//  ClipBoardManager
//
//  Created by Lennard Kittner on 18.08.18.
//  Copyright © 2018 Lennard Kittner. All rights reserved.
//

import Cocoa

class PreferencefViewController: NSTabViewController {
    
    @IBOutlet weak var display: NSTextField!
    @IBOutlet weak var gitHub: NSButtonCell!
    @IBOutlet weak var atLogin: NSButton!
    @IBOutlet weak var refresh: NSTextField!
    @IBOutlet weak var preview: NSTextField!
    
    private var configHandler :ConfigHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        configHandler = (NSApplication.shared.delegate as! AppDelegate).configHandler
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if display != nil {
            display.stringValue = String(configHandler.conf.clippingCount)
            refresh.stringValue = String(configHandler.conf.refreshTime)
            preview.stringValue = String(configHandler.conf.previewWidth)

            atLogin.state = NSControl.StateValue(rawValue: configHandler.conf.startAtLogin ? 1 : 0)
        }
        if gitHub != nil {
            let blue = NSColor.linkColor
            let attributedStringColor = [NSAttributedString.Key.foregroundColor : blue];
            let title = NSAttributedString(string: "My GitHub", attributes: attributedStringColor)
            gitHub.attributedTitle = title
        }
        self.parent?.view.window?.title = self.title!
    }
    
    @IBAction func autoStart(_ sender: NSButton) {
        let newConf = (configHandler.conf.copy() as! ConfigData)
        newConf.startAtLogin.toggle()
        configHandler.conf = newConf
    }
    
    @IBAction func displayChange(_ sender: NSTextField) {
        if sender.intValue > 0 {
            let newConf = (configHandler.conf.copy() as! ConfigData)
            newConf.clippingCount = Int(sender.intValue)
            configHandler.conf = newConf
        }
        sender.intValue = Int32(configHandler.conf.clippingCount)
    }
    
    @IBAction func refreshChange(_ sender: NSTextField) {
        if sender.doubleValue > 0.0 {
            let newConf = (configHandler.conf.copy() as! ConfigData)
            newConf.refreshTime = Double(sender.doubleValue)
            configHandler.conf = newConf
        }
        sender.doubleValue = configHandler.conf.refreshTime
    }
    
    @IBAction func previewChange(_ sender: NSTextField) {
        if sender.intValue > 0 {
            let newConf = (configHandler.conf.copy() as! ConfigData)
            newConf.previewWidth = Int(sender.intValue)
            configHandler.conf = newConf
        }
        sender.intValue = Int32(configHandler.conf.previewWidth)
    }
    
    @IBAction func openGitHub(_ sender: Any) {
        let url = URL(string: "https://github.com/Lennard599")!
        NSWorkspace.shared.open(url)
    }
    
}
