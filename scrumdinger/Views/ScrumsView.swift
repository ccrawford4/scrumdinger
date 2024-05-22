//
//  ScrumsView.swift
//
//  Created by Calum Crawford on 5/12/24.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewScrumView = false
    @State private var selectedScrum: DailyScrum?
    @State private var showRemoveScrumView = false
    let saveAction: ()->Void
    
    var body: some View {
        ZStack {
            NavigationStack {
                List($scrums) { $scrum in
                    NavigationLink(destination: DetailView(scrum: $scrum)) {
                        CardView(scrum: scrum)
                    }
                    .swipeActions {
                        Button() {
                            selectedScrum = scrum
                            showRemoveScrumView = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                    .listRowBackground(scrum.theme.mainColor)
                }
                .navigationTitle("Daily Scrums")
                .toolbar {
                    Button(action: {
                        isPresentingNewScrumView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New Scrum")
                }
            }
            .sheet(isPresented: $isPresentingNewScrumView) {
                NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)
                
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
            }
            if showRemoveScrumView, let scrum = selectedScrum {
                RemoveScrumView(scrums: scrums, scrum: scrum,
                                onCancel: {
                                    showRemoveScrumView = false
                                },
                                onConfirm: {
                                    if let index = scrums.firstIndex(where: { $0.id == scrum.id }) {
                                        scrums.remove(at: index)}
                                    showRemoveScrumView = false
                                }
                )
                .frame(width: 300, height: 200)
                .cornerRadius(10)
                .shadow(radius: 10)
                .transition(.scale)
                .zIndex(1)
            }
        }
    }
    
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
    }
}
