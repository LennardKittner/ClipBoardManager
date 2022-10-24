//
//  ConfigData.swift
//  SettingsSwitfUI
//
//  Created by Lennard on 04.10.22.
//

import Foundation


func ==(op1: ConfigData, op2: ConfigData) -> Bool {
    return op1.atLogin == op2.atLogin
        && op1.previewLength == op2.previewLength
        && op1.clippings == op2.clippings
        && (abs(op1.refreshIntervall-op2.refreshIntervall) < Float.ulpOfOne * abs(op1.refreshIntervall+op2.refreshIntervall))
}

final class ConfigData: Decodable, Encodable {
    var clippings :Int
    var refreshIntervall :Float
    var previewLength :Int
    var atLogin :Bool
    
    enum CodingKeys: CodingKey {
        case clippings
        case refreshIntervall
        case previewLength
        case atLogin
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clippings = try container.decode(Int.self, forKey: .clippings)
        self.refreshIntervall = try container.decode(Float.self, forKey: .refreshIntervall)
        self.previewLength = try container.decode(Int.self, forKey: .previewLength)
        self.atLogin = try container.decode(Bool.self, forKey: .atLogin)
    }
    
    init() {
        clippings = 10
        refreshIntervall = 0.5
        previewLength = 40
        atLogin = false
    }
    
    init(copy: ConfigData) {
        clippings = copy.clippings
        refreshIntervall = copy.refreshIntervall
        previewLength = copy.previewLength
        atLogin = copy.atLogin
    }
}
