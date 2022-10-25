//
//  ConfigHandler.swift
//  CPUMonitor
//
//  Created by Lennard on 05.08.22.
//  Copyright © 2022 Lennard Kittner. All rights reserved.
//

import Foundation

class ConfigParser {
    
    static func parseStringToMap(content :String) -> [String : String] {
        var keyValue: [String : String] = [:]
        for line in content.components(separatedBy: "\n") {
            let con = line.components(separatedBy: ": ")
            if con.count >= 2 {
                keyValue[con[0]] = con[1] + con[2..<con.count].reduce("", {a, s in a + ": " + s})
            }
        }
        
        return keyValue
    }

    static func parseMapToObj<T :NSObject>(keyValue :[String : Any], target :T) {
        let reflection = Mirror(reflecting: target)
        
        for child in reflection.children {
            if child.label != nil && keyValue[child.label!] != nil {
                target.setValue(keyValue[child.label!], forKey: child.label!)
            }
        }
    }

    static func parseMapToString(keyValue :[String : Any]) -> String {
        return keyValue.reduce("", {a, kv  in a + kv.key + ": " + String(describing: kv.value) + "\n"})
    }

    static func parseObjToMap<T :NSObject>(content :T) -> [String : Any] {
        let reflection = Mirror(reflecting: content)
        var keyValue: [String : Any] = [:]

        for child in reflection.children {
            if child.label != nil {
                keyValue[child.label!] = child.value
            }
        }

        return keyValue
    }
}
