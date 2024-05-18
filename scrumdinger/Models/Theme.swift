//
//  Theme.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
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
            case .bubblegum: return Color("bubblegumColorSet")
            case .buttercup: return Color("buttercupColorSet")
            case .indigo: return Color("indigoColorSet")
            case .lavender: return Color("lavenderColorSet")
            case .magenta: return Color("magentaColorSet")
            case .navy: return Color("navyColorSet")
            case .orange: return Color("orangeColorSet")
            case .oxblood: return Color("oxbloodColorSet")
            case .periwinkle: return Color("periwinkleColorSet")
            case .poppy: return Color("poppyColorSet")
            case .purple: return Color("purpleColorSet")
            case .seafoam: return Color("seafoamColorSet")
            case .sky: return Color("skyColorSet")
            case .tan: return Color("tanColorSet")
            case .teal: return Color("tealColorSet")
            case .yellow: return Color("yellowColorSet")
            }
        }
    
    var name: String {
        rawValue.capitalized
    }
    
    var id: String {
        name
    }
}


