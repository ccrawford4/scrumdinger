//
//  ScrumsView.swift
//  Hello_World
//
//  Created by Calum Crawford on 5/12/24.
//

import SwiftUI

struct ScrumsView: View {
    let scrums: [DailyScrum]
    
    var body: some View {
        List(scrums) {
            scrum in
            CardView(scrum: scrum)
            // Should be different colors
                .listRowBackground(scrum.theme.mainColor)
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: DailyScrum.sampleData)
    }
}
