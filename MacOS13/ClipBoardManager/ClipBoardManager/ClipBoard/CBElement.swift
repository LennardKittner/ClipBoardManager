//
//  CBElement.swift
//  ClipBoardManager
//
//  Created by Lennard on 21.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Cocoa

class CBElement {
    var string :String
    var isFile :Bool
    var content :[NSPasteboard.PasteboardType : Data]
    
    init() {
        isFile = false
        string = ""
        content = [:]
    }
    
    convenience init(from map: [String : String]) {
        self.init()
        string = map["string"] ?? ""
        isFile = map["isFile"] == "true"
        for (k, v) in map {
            if k != "string" && k != "isFile" {
                content[NSPasteboard.PasteboardType(k)] = Data(base64Encoded: v)
            }
        }
    }
    
    init(string: String, isFile: Bool, content: [NSPasteboard.PasteboardType : Data]) {
        self.string = string
        self.isFile = isFile
        self.content = content
    }
    
    func toMap() -> [String : String] {
        var stringDict :[String : String] = [:]
        stringDict["string"] = string
        stringDict["isFile"] = isFile ? "true" : "false"
        for (k, d) in content {
            stringDict[k.rawValue] = d.base64EncodedString()
        }
        return stringDict
    }
}


