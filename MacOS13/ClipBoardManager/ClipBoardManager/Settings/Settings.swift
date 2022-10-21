//
//  Settings.swift
//  SettingsSwitfUI
//
//  Created by Lennard on 02.10.22.
//

import SwiftUI
import Combine


struct Settings: View {
    @EnvironmentObject private var configHandler :ConfigHandler
    @State private var error = [false, false, false]
    
    func validatePositiveInt(_ string: String) -> Int? {
        if let num = Int(string) {
            if num > 0 {
                return num
            }
        }
        return nil
    }
    
    func validatePositiveFloat(_ string: String) -> Float? {
        if let num = Float(string) {
            if num > 0 {
                return num
            }
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if error.reduce(false, {$0 || $1}) {
            Text("Please enter a positive \(error[1] ? "" : "whole ")number")
                    .foregroundColor(.red)
            }
            HStack {
                Text("Number Clippings: ")
                ValidatedTextField(content: $configHandler.conf.clippings, error: $error[0], validate: validatePositiveInt(_:))
                    .frame(width: 100)
            }
            HStack {
                Text("Refresh intervall:")
                    .padding(.trailing, 14)
                ValidatedTextField(content: $configHandler.conf.refreshIntervall, error: $error[1], validate: validatePositiveFloat(_:))
                    .frame(width: 100)
                Text("seconds")
            }
            HStack {
                Text("Preview length:")
                    .padding(.trailing, 22.5)
                ValidatedTextField(content: $configHandler.conf.previewLength, error: $error[2], validate: validatePositiveInt(_:))
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
