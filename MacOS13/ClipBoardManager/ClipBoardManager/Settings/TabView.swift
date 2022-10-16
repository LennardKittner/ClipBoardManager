//
//  ToolBarView.swift
//  SettingsSwitfUI
//
//  Created by Lennard on 05.10.22.
//

import SwiftUI

struct TabView: View {
    @EnvironmentObject private var configHandler :ConfigHandler
    @Binding var currentTab :Int

    var body: some View {
        Section {
            if currentTab == 0 {
                About()
            } else if currentTab == 1 {
                Settings()
                    .environmentObject(configHandler)
            }
        }
        .frame(width: 450, height: 150)
   }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(currentTab: .constant(0))
    }
}
