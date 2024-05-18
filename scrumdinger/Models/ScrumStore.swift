//
//  ScrumStore.swift
//  scrumdinger
//
//  Created by Calum Crawford on 5/18/24.
//

import Foundation
import SwiftUI

// Makes it safe to update published scrums property from async load() method
@MainActor
class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    private static func fileUrl() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("scrums.data")
    }
    
    func load() async throws {
        let task = Task<[DailyScrum], Error> {
            let fileUrl = try Self.fileUrl()
            guard let data = try? Data(contentsOf: fileUrl) else {
                return []
            }
            let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: data)
            return dailyScrums
        }
        let scrums = try await task.value
        self.scrums = scrums;
    }
    
    func save(scrums: [DailyScrum]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(scrums)
            let outfile = try Self.fileUrl()
            try data.write(to: outfile)
        }
        // Not actually interested in the task.value just need to wait to get errors for caller
        _ = try await task.value
    }
}
