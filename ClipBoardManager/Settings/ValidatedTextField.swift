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
    @State var valueProxy = ""
    var title = ""
    var validate :(String) -> T?
    
    func update(value: String) {
        if let newValue = validate(value) {
            self.content = newValue
        }
    }
    
    var body: some View {
//        let valueProxy = Binding<String>(
//            get: { "\(self.content)" },
//            set: {
//              if let newValue = validate($0) {
//                  error = false
//                  self.content = newValue
//              } else {
//                  error = true
//              }
//            }
//        )
        
        return HStack {
            TextField(title, text: $valueProxy, onEditingChanged: {focus in
                if !focus {
                    update(value: valueProxy)
                }
            })
            .onChange(of: valueProxy) { value in
                error = validate(value) == nil
            }
            .onAppear {
                valueProxy = "\(content)"
            }
            .onDisappear {
                update(value: valueProxy)
            }
            .border(error ? Color.red : Color(red: 0, green: 0, blue: 0, opacity: 0))
        }
    }
}

