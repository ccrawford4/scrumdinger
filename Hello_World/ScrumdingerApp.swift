//
//  ScrumdingerApp.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData
    
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $scrums)
        }
    }
}
