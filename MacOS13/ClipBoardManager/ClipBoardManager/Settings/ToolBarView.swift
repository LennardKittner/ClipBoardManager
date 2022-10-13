//
//  ToolBarView.swift
//  SettingsSwitfUI
//
//  Created by Lennard on 05.10.22.
//

import SwiftUI

struct ToolBarView: View {
    @StateObject private var configHandler = ConfigHandler()

    private let tabs = ["About", "Settings"]
    @State private var currentTab = 0
    @State private var showText = true

   var body: some View {
       Section {
           if currentTab == 0 {
               About()
           } else if currentTab == 1 {
               Settings()
                   .environmentObject(configHandler)
           }
       }
       .toolbar {
           ToolbarItem(placement: .navigation) {
               Picker("", selection: $currentTab) {
                   ForEach(tabs.indices) { i in
                       Text(tabs[i]).tag(i)
                   }
               }
               .pickerStyle(SegmentedPickerStyle())
               .padding(.top, 8)
           }
       }
       .frame(width: 450, height: 150)
   }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView()
    }
}

struct ToolbarView: View {
    private let tabs = ["About", "Settings"]
    @State private var currentTab = 0

    var body: some View {
        Picker("", selection: $currentTab) {
            ForEach(tabs.indices) { i in
                Text(tabs[i]).tag(i)
            }
        }
    }
}
