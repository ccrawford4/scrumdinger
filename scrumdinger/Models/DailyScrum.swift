//
//  DailyScrum.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import Foundation

// Codable -> Allows you to use the Codable API to easily serialize data to and from JSON
struct DailyScrum: Identifiable, Codable, Equatable {
    static func == (lhs: DailyScrum, rhs: DailyScrum) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.attendees == rhs.attendees &&
        lhs.lengthInMinutes == rhs.lengthInMinutes &&
        lhs.theme == rhs.theme &&
        lhs.history == rhs.history
    }
    
    
    let id: UUID
    var title: String
    var attendees: [Attendee]
    var lengthInMinutes: Int
    var lengthInMinutesAsDouble: Double {
        get {
            Double(lengthInMinutes)
        }
        set {
            lengthInMinutes = Int(newValue)
        }
    }
    
    var theme: Theme
    var history: [History] = []
    
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        
        // Based on current Attendee data -> bypass string init paramater
        self.attendees = attendees.map { Attendee(name: $0) }
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}

extension DailyScrum {
    struct Attendee: Identifiable, Codable, Equatable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
    
    static var emptyScrum: DailyScrum {
        DailyScrum(title: "", attendees: [], lengthInMinutes: 5, theme: .sky)
    }
}

extension DailyScrum {
    struct MockScrumAttendee: Identifiable, Codable, Equatable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
}

extension DailyScrum {
    static let sampleData: [DailyScrum] =
    [
        DailyScrum(title: "Design",
                   attendees: ["Cathy", "Daisy", "Simon", "Jonathan"],
                   lengthInMinutes: 10,
                   theme: .yellow),
        DailyScrum(title: "App Dev",
                   attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"],
                    lengthInMinutes: 5,
                   theme: .orange),
        DailyScrum(title: "Web Dev",
                   attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"],
                  lengthInMinutes: 5,
                   theme: .poppy)
    ]
}
