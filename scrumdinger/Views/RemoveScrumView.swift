//
//  RemoveScrumView.swift
//  scrumdinger
//
//  Created by Calum Crawford on 5/20/24.
//

import SwiftUI

struct RemoveScrumView: View {
    var scrumTitle: String
    var body: some View {
        Text("Are you sure you want to delete the \(scrumTitle) Scrum?")
        VStack {
            Button(action: {}) {
                Text("Yes")
            }
            Button(action: {}) {
                Text("No")
            }
        }
    }
}

struct RemoveScrumView_Previews: PreviewProvider {
    static var title: String = DailyScrum.sampleData[0].title
    static var previews: some View {
        RemoveScrumView(scrumTitle: title)
    }
}
