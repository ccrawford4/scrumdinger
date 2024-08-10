//
//  Hello_WorldTests.swift
//  Hello_WorldTests
//
//  Created by Calum Crawford on 5/12/24.
//

import XCTest
@testable import scrumdinger
import AVFoundation

@MainActor
final class HelloWorld_TestsLaunch: XCTestCase {
    // UNIT TEST CLASS
    var mockScrums: [DailyScrum] = DailyScrum.sampleData
    let scrumStore = ScrumStore()
    
    // ************** JSON TESTS ************************
    
    // fileURL() function needed for other tests
    func fileUrl() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("scrums.data")
    }
    
    // Test the fileUrl() function first
    func testFileUrl() {
        do {
            let url = try fileUrl()
            
            // Validate the URL is in the document directory
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                                appropriateFor: nil, create: false)
            XCTAssertTrue(url.path.starts(with: documentDirectory.path))
            
            // Validate that the file name is correct
            XCTAssertEqual(url.lastPathComponent, "scrums.data", "The URL should end with 'scrums.data'")
        }
        catch {
            XCTFail("The fileUrl() function should not throw an error. Error: \(error.localizedDescription)")
        }
    }
    
    // Test loading data
    func testLoad() throws {
        let expectation = XCTestExpectation(description: "Load scrums")
        
        let mockData = try JSONEncoder().encode(mockScrums)
        try mockData.write(to: fileUrl())
        
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
    
    // Test saving data
    func testSave() throws {
        let expectation = XCTestExpectation(description: "Save scrums")
        
        // Use a mock data for testing
        let mockScrums = DailyScrum.sampleData
        
        Task {
            do {
                try await scrumStore.save(scrums: mockScrums)
                let data = try Data(contentsOf: fileUrl())
                let savedScrums = try JSONDecoder().decode([DailyScrum].self, from: data)
                XCTAssertEqual(savedScrums, mockScrums)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to save scrums with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // ************* TIMER TESTS ******************
    
    // Test starting a scrum
    func testStartScrum() {
        let mockScrum: DailyScrum = mockScrums[0]
        let timerClass: ScrumTimer = ScrumTimer(lengthInMinutes: 1, attendees: mockScrum.attendees)
        
        timerClass.startScrum()
        
        // Test that timer is scheduled
        XCTAssertNotNil(timerClass.getTimer(), "Timer should be initialized")
        XCTAssertEqual(timerClass.getTimer()?.timeInterval, timerClass.getFrequency(), "Timer interval should be set to frequency")
        
        // Wait to ensure that update() is called
        let expectation = XCTestExpectation(description: "timer Fired")
        DispatchQueue.main.asyncAfter(deadline: .now() + timerClass.getFrequency() + 0.2) {
            XCTAssertTrue(timerClass.updateCalled(), "update() should now be called by the timer")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timerClass.getFrequency() + 0.5)
    }
    
    // Test stopping a scrum
    func testStopScrum() {
        let mockScrum: DailyScrum = mockScrums[0]
        let timerClass: ScrumTimer = ScrumTimer(lengthInMinutes: 1, attendees: mockScrum.attendees)
        let expectation = XCTestExpectation(description: "Stop Scrum")
        
        timerClass.startScrum()
        timerClass.stopScrum()
        
        // Ensure that the timer stopped variable was triggered
        XCTAssertEqual(timerClass.getTimerStopped(), true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timerClass.getFrequency() + 0.1) {
            // Timer should no longer be valid
            if let timer = timerClass.getTimer(), timer.isValid {
                XCTFail("Timer should be invalidated")
            } else {
                // Timer was successfully invalidated
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timerClass.getFrequency() + 0.5)
    }
    
    // Test changing the speaker
    func testChangeToSpeaker() {
        // mockScrum speaker order: ["Cathy", "Daisy", "Simon", "Jonathan"]
        let mockScrum: DailyScrum = mockScrums[0]
        let timerClass: ScrumTimer = ScrumTimer(lengthInMinutes: 1, attendees: mockScrum.attendees)
        let expectation = XCTestExpectation(description: "Change Speaker")
        timerClass.startScrum()
        
        // Since we are changing at index 2 -> ensure the previous one is considered complete
        timerClass.changeToSpeaker(at: 2)
        XCTAssertTrue(timerClass.speakers[1].isCompleted == true)
        
        // The new current speaker should be simon
        XCTAssertEqual(timerClass.activeSpeaker, "Speaker 3: Simon")
    }
    
    // **************  AVPLAYER TESTS ********************
    
    // Test a valid call to the custom player
    func testValidResourceAndExtension () {
        do {
            let player: AVPlayer = try AVPlayer.customPlayer(resource: "ding", resourceExtension: "wav")
            XCTAssertNotNil(player.currentItem, "The AV Player should have a current item.")
            
            let expectation = XCTestExpectation(description: "The AVPlayer should be ready to play")
            let observation = player.currentItem?.observe(\.status, options: [.new], changeHandler: { (item, change) in
                if item.status == .readyToPlay {
                    expectation.fulfill()
                }
            })
        } catch {
            XCTFail("Failed to create AVPlayer")
        }
    }
    
    // Test an invalid resource parameter for the AVPlayer custom player
    func testInvalidResource() {
        do {
            _ = try AVPlayer.customPlayer(resource: "fake-resource", resourceExtension: "wav")
            XCTFail("Expected to fail but succeeded")
        } catch AVPlayerError.resourceNotFound(let resource, let resourceExtension) {
            XCTAssertEqual(resource, "fake-resource")
            XCTAssertEqual(resourceExtension, "wav")
        }
        catch {
            XCTFail("UnexpectedError: \(error)")
        }
    }
    
    // Test an invalid resource parameter for the AVPlayer custom player
    func testInvalidResourceExtension() {
        do {
            _ = try AVPlayer.customPlayer(resource: "ding", resourceExtension: "mp3")
            XCTFail("Expected to fail but succeeded")
        } catch AVPlayerError.resourceNotFound(let resource, let resourceExtension) {
            XCTAssertEqual(resource, "ding")
            XCTAssertEqual(resourceExtension, "mp3")
        }
        catch {
            XCTFail("UnexpectedError: \(error)")
        }
    }
    
}
