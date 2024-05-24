//
//  History.swift
//  scrumdinger
//
//  Created by Calum Crawford on 5/17/24.
//

import SwiftUI

struct History: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    var attendees: [DailyScrum.Attendee]
    var transcript: String?
    
    init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], transcript: String? = nil) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.transcript = transcript
    }
}
