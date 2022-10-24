//
//  Toolbar.swift
//  ClipBoardManager
//
//  Created by Lennard on 16.10.22.
//

import SwiftUI

struct Toolbar: View {
    let tabs :[String]
    @Binding var currentTab :Int
    
    var body: some View {
        Picker("", selection: $currentTab) {
            ForEach(tabs.indices) { i in
                Text(tabs[i]).tag(i)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 100)
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar(tabs: ["About", "Settings"], currentTab: .constant(0))
    }
}
