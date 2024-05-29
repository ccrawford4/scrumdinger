//
//  ContentView.swift
//
//  Created by Calum Crawford on 5/12/24.
//

import SwiftUI
import AVFoundation

struct ActionWrapper {
    var action: ()->Void
}

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var player: AVPlayer?
    @State private var errorMessage: String?
    @State private var errorWrapper: ErrorWrapper?
    
    var resource = "ding"
    var resourceExtension = "wav"
    
    init(scrum: Binding<DailyScrum>) {
        self._scrum = scrum
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.theme)
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
            .padding()
            .foregroundColor(scrum.theme.accentColor)
            .onAppear {
                setUpPlayer()
                startScrum()
            }
            .onDisappear {
                endScrum()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $errorWrapper) {}
        content: { wrapper in
            ErrorView(errorWrapper: wrapper)
        }
        
    }
        
    private func startScrum() {
        scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
        // Ensure audio plays from beginning
        scrumTimer.speakerChangedAction = {
            player?.seek(to: .zero)
            player?.play()
        }
        // Reset the transcription and start again
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
        
        // Start the scrum
        scrumTimer.startScrum()
    }
    private func endScrum() {
        scrumTimer.stopScrum();
        speechRecognizer.stopTranscribing()
        isRecording = false
        let newHistory = History(attendees: scrum.attendees, transcript: speechRecognizer.transcript)
        scrum.history.insert(newHistory, at: 0)
    }
    
    private func setUpPlayer() {
        do {
            player = try AVPlayer.customPlayer(resource: resource, resourceExtension: resourceExtension)
        } catch let error as AVPlayerError {
            errorMessage = "Failed to load sound file: \(resource).\(resourceExtension)"
            errorWrapper = ErrorWrapper(error: error, guidance: "Cannot Load Audio File. Please Try Again Later")
        }
        catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
            errorWrapper = ErrorWrapper(error: error, guidance: "Please Try Again Later")
        }
    }
        
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
