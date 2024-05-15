//
//  Theme.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    var accentColor: Color {
        switch self {
            case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky,
                .tan, .teal, .yellow: return Color("colorB")
            case .indigo, .magenta, .navy, .oxblood, .purple: return Color("colorW")
        }
    }
    
    var mainColor: Color {
            switch self {
            case .bubblegum: return Color("bubblegumColor")
            case .buttercup: return Color("buttercupColor")
            case .indigo: return Color("indigoColor")
            case .lavender: return Color("lavenderColor")
            case .magenta: return Color("magentaColor")
            case .navy: return Color("navyColor")
            case .orange: return Color("orangeColor")
            case .oxblood: return Color("oxbloodColor")
            case .periwinkle: return Color("periwinkleColor")
            case .poppy: return Color("poppyColor")
            case .purple: return Color("purpleColor")
            case .seafoam: return Color("seafoamColor")
            case .sky: return Color("skyColor")
            case .tan: return Color("tanColor")
            case .teal: return Color("tealColor")
            case .yellow: return Color("yellowColor")
            }
        }
    
    var name: String {
        rawValue.capitalized
    }
    
    var id: String {
        name
    }
}


