//
//  Settings.swift
//  SettingsSwitfUI
//
//  Created by Lennard on 02.10.22.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject private var configHandler :ConfigHandler
    
    let floatFormater :NumberFormatter = {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        return formater
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Number Clippings: ")
                TextField("clippings", value: $configHandler.conf.clippings, formatter: NumberFormatter(), onEditingChanged: {focus in
                    if !focus {
                        
                    }
                })
                .frame(width: 100)
            }
            HStack {
                Text("Refresh intervall:")
                    .padding(.trailing, 14)
                TextField("Refresh intervall", value: $configHandler.conf.refreshIntervall, formatter: floatFormater, onEditingChanged: {focus in
                    if !focus {
                        
                    }
                })
                .frame(width: 100)
                Text("seconds")
            }
            HStack {
                Text("Preview length:")
                    .padding(.trailing, 22.5)
                TextField("Preview length", value: $configHandler.conf.previewLength, formatter: NumberFormatter(), onEditingChanged: {focus in
                    if !focus {
                        
                    }
                })
                .frame(width: 100)
            }
            HStack {
                Text("Start at login:")
                    .padding(.trailing, 35)
                Toggle(isOn: $configHandler.conf.atLogin) {
                    
                }
                .toggleStyle(CheckboxToggleStyle())
            }
        }
        .padding(.leading, -95.0)
    }


}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(ConfigHandler())
            .frame(width: 450, height: 150)
    }
}
