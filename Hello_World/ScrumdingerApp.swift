//
//  ScrumdingerApp.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: DailyScrum.sampleData)
        }
    }
}
