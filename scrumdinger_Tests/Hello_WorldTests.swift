//
//  Hello_WorldTests.swift
//  Hello_WorldTests
//
//  Created by Calum Crawford on 5/12/24.
//

import XCTest
@testable import scrumdinger

final class ScrumdingerTests: XCTestCase {
    var mockScrums: [DailyScrum] = DailyScrum.sampleData
    let scrumStore = ScrumStore()
    
    override func setUpWithError() throws {
            
    }

    override func tearDownWithError() throws {

    }

    func testLoad() throws {
        let expectation = XCTestExpectation(description: "Load scrums")
            
            // Use a mock data for testing
        let mockScrums = DailyScrum.sampleData
        let mockData = try JSONEncoder().encode(mockScrums)
        try mockData.write(to: scrumStore.fileUrl())
            
        Task {
            do {
                try await scrumStore.load()
                XCTAssertEqual(scrumStore.scrums, mockScrums)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to load scrums with error: \(error.localizedDescription)")
            }
        }
            
        wait(for: [expectation], timeout: 5.0)
    }

        func testSave() throws {
            let expectation = XCTestExpectation(description: "Save scrums")

            // Use a mock data for testing
            let mockScrums = DailyScrum.sampleData
            
            Task {
                do {
                    try await scrumStore.save(scrums: mockScrums)
                    let data = try Data(contentsOf: scrumStore.fileUrl())
                    let savedScrums = try JSONDecoder().decode([DailyScrum].self, from: data)
                    XCTAssertEqual(savedScrums, mockScrums)
                    expectation.fulfill()
                } catch {
                    XCTFail("Failed to save scrums with error: \(error.localizedDescription)")
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }

}
