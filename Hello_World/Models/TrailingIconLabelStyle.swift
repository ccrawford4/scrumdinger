//
//  TrailingIconLabelStyle.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title     // Label's Title
            configuration.icon    // Label's Icon Image
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
