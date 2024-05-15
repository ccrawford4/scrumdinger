//
//  ThemePicker.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/14/24.
//

import SwiftUI

struct ThemePicker: View {
    // this binding communicates changes to the theme within the theme picker back to the parent view
    
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    .tag(theme)
            }
        }
        .pickerStyle(.navigationLink)
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        ThemePicker(selection: .constant(.periwinkle))
    }
}
