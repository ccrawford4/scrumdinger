//
//  DetailView.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import SwiftUI

struct DetailView: View {
    let scrum: DailyScrum
    var body: some View {
        Text("Hello, World!")
    }
}

// Default way to create a view
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(scrum: DailyScrum.sampleData[0])
        }
    }
}
