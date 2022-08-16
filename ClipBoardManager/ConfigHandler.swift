//
//  ConfigHandler.swift
//  CPUMonitor
//
//  Created by Lennard on 06.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Foundation

//TODO change cfg path

class ConfigHandler {
    // /Users/<name>/Library/Containers/com.Lennard.CPUMonitor/Data/Library/"Application Support"/ClipBoardManager/
    let conf_dir = URL(fileURLWithPath: "\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path)/ClipBoardManager/")
    let conf_file = URL(fileURLWithPath: "\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path)/ClipBoardManager/ClipBoardManager.cfg")

    let onChange :(ConfigData) -> Void
    private var _conf :ConfigData
    var conf: ConfigData {
        get { return _conf }
        set {
            _conf = newValue
            onChange(_conf)
        }
    }
    
    init(onChange :@escaping (ConfigData) -> Void) {
        self.onChange = onChange
        self._conf = ConfigData()
        
        if !FileManager.default.fileExists(atPath: (conf_file.path)) {
            writeCfg()
        } else {
            readCfg()
        }
    }
    
    func readCfg() {
        let conf = ConfigData()
        if let content = try? String.init(contentsOf: conf_file) {
            ConfigParser.parseMapToObj(keyValue: ConfigParser.parseStringToMap(content: content), target: conf)
        }
        self.conf = conf
    }
    
    func writeCfg() {
        let config = ConfigParser.parseMapToString(keyValue: ConfigParser.parseObjToMap(content: _conf))
        if !FileManager.default.fileExists(atPath: (conf_file.path)) {
            try! FileManager.default.createDirectory(atPath: conf_dir.path, withIntermediateDirectories: true, attributes: nil)
            FileManager.default.createFile(atPath: (conf_file.path), contents: config.data(using: String.Encoding.utf8, allowLossyConversion: false)!, attributes: nil)
            return
        }
        try! config.write(to: conf_file, atomically: true, encoding: String.Encoding.utf8)
    }
}
