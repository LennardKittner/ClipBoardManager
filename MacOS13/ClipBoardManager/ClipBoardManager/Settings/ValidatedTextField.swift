//
//  ValidatedTextField.swift
//  ClipBoardManager
//
//  Created by Lennard on 16.10.22.
//

import SwiftUI


struct ValidatedTextField<T> :View {
    @Binding var content :T
    @Binding var error :Bool
    var title = ""
    var validate :(String) -> T?
    var onFocusLost :() -> ()
    
    var body: some View {
        let valueProxy = Binding<String>(
            get: { "\(self.content)" },
            set: {
              if let newValue = validate($0) {
                  error = false
                  self.content = newValue
              } else {
                  error = true
              }
            }
        )
        
        return HStack {
            TextField(title, text: valueProxy, onEditingChanged: {focus in
                if !focus {
                    onFocusLost()
                }
            })
            .border(error ? Color.red : Color(red: 0, green: 0, blue: 0, opacity: 0))
            .onDisappear {
                onFocusLost()
            }
        }
    }
}

