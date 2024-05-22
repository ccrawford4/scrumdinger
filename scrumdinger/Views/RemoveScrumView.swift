//
//  RemoveScrumView.swift
//  scrumdinger
//
//  Created by Calum Crawford on 5/20/24.
//

import SwiftUI

struct RemoveScrumView: View {
    @State var scrums: [DailyScrum]
    let scrum: DailyScrum
    var onCancel: () -> Void
    var onConfirm: ()->Void
    
    var body: some View {
        VStack {
            Text("Are you sure you want to delete \(scrum.title)?")
            HStack {
                Button(action: onConfirm) {
                    Text("Yes")
                }
                Button(action: onCancel) {
                    Text("No")
                }
            }
            .padding(.top)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        
    }
}

struct RemoveScrumView_Previews: PreviewProvider {
    static var scrums: [DailyScrum] = DailyScrum.sampleData
    static var previews: some View {
        RemoveScrumView(scrums: scrums, scrum: scrums[0], onCancel: {}, onConfirm: {})
    }
}
