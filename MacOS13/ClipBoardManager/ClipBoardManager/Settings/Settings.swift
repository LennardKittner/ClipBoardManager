//
//  Settings.swift
//  SettingsSwitfUI
//
//  Created by Lennard on 02.10.22.
//

import SwiftUI
import Combine

//TODO: check input with formater or in onEditingChanged
struct Settings: View {
    @EnvironmentObject private var configHandler :ConfigHandler
    @State private var error = [false, false, false]
    
    let floatFormater :NumberFormatter = {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        return formater
    }()
    
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
            HStack {
                Text("Number Clippings: ")
                ValidatedTextField(content: $configHandler.conf.clippings, error: $error[0], validate: validatePositiveInt(_:), onFocusLost: {configHandler.submit.toggle()})
                    .frame(width: 100)
                if error[0] {
//                    Text("Please enter a positive number")
//                        .foregroundColor(Color.red)
                }
            }
            HStack {
                Text("Refresh intervall:")
                    .padding(.trailing, 14)
                ValidatedTextField(content: $configHandler.conf.refreshIntervall, error: $error[1], validate: validatePositiveFloat(_:), onFocusLost: {configHandler.submit.toggle()})
                    .frame(width: 100)
                Text("seconds")
                if error[1] {
//                    Text("Please enter a positive number")
//                        .foregroundColor(Color.red)
                }
            }
            HStack {
                Text("Preview length:")
                    .padding(.trailing, 22.5)
                ValidatedTextField(content: $configHandler.conf.previewLength, error: $error[2], validate: validatePositiveInt(_:), onFocusLost: {configHandler.submit.toggle()})
                    .frame(width: 100)
                if error[2] {
//                    Text("Please enter a positive number")
//                        .foregroundColor(Color.red)
                }
            }
            HStack {
                Text("Start at login:")
                    .padding(.trailing, 35)
                Toggle(isOn: $configHandler.conf.atLogin) {
                    
                }
                .toggleStyle(CheckboxToggleStyle())
            }
        }.onDisappear {
            configHandler.submit.toggle()
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
