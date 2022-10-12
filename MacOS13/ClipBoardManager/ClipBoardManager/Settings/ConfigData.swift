//
//  ConfigData.swift
//  SettingsSwitfUI
//
//  Created by Lennard on 04.10.22.
//

import Foundation

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
