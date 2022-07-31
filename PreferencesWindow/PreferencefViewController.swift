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
    @IBOutlet weak var licenses: NSButton!
    
    var appDelegate :AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        appDelegate = (NSApplication.shared.delegate as! AppDelegate)
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if display != nil {
            display.stringValue = String(appDelegate?.max_display ?? 20)
            refresh.stringValue = String(appDelegate?.refreshTime ?? 0.5)
            preview.stringValue = String(appDelegate?.preview_length ?? 40)

            atLogin.state = NSControl.StateValue(rawValue: (appDelegate?.startAtLogin)! ? 1 : 0)
        }
        if gitHub != nil {
            let blue = NSColor.linkColor
            let attributedStringColor = [NSAttributedStringKey.foregroundColor : blue];
            let title = NSAttributedString(string: "My GitHub", attributes: attributedStringColor)
            gitHub.attributedTitle = title
            
            let license_t = NSAttributedString(string: "Licenses", attributes: attributedStringColor)
            
            licenses.attributedTitle = license_t
        }
        //update Title
        self.parent?.view.window?.title = self.title!
    }
    
    func writeConf() {
        let conf_txt = """
        Display:\(String((appDelegate?.max_display)!))
        AtLogin:\((appDelegate?.startAtLogin)! ? "yes" : "no")
        Refresh:\(String((appDelegate?.refreshTime)!))
        Preview:\(String((appDelegate?.preview_length)!))
        """
        try! conf_txt.write(to: (appDelegate?.conf_file)!, atomically: true, encoding: String.Encoding.utf8)
    }
    
    @IBAction func autoStart(_ sender: NSButton) {
        appDelegate?.startAtLogin = !((appDelegate?.startAtLogin)!)
        appDelegate?.setStartAtLogin()
        writeConf()
    }
    
    @IBAction func displayChange(_ sender: NSTextField) {
        if sender.intValue > 0 {
            appDelegate!.max_display = Int(sender.intValue)
            //appDelegate?.refreshMenu()
            writeConf()
        }
    }
    
    @IBAction func refreshChange(_ sender: NSTextField) {
        if sender.doubleValue > 0.0 {
            appDelegate!.refreshTime = Double(sender.doubleValue)
            appDelegate?.timer?.invalidate()
            appDelegate?.startTimer(wait: appDelegate?.refreshTime ?? 0.5)
            writeConf()
        }
    }
    
    @IBAction func previewChange(_ sender: NSTextField) {
        if sender.intValue > 0 {
            appDelegate!.preview_length = Int(sender.intValue)
            //appDelegate?.refreshMenu()
            writeConf()
        }
    }
    
    @IBAction func openGitHub(_ sender: Any) {
        let url = URL(string: "https://github.com/Lennard599")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func openLicenses(_ sender: Any) {
        let url = URL(string: "http://lennardkittner.ml")!
        NSWorkspace.shared.open(url)
    }
    
}
