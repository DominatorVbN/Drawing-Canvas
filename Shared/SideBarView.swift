//
//  SideBarView.swift
//  Drawing Canvas (iOS)
//
//  Created by Amit Samant on 10/06/21.
//

import SwiftUI

struct SideBarView: View {
    @State var selection: LineType?
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DrawView(lineType: .constant(.follow)), tag: LineType.follow, selection: $selection) {
                    Label("Follow", systemImage: "hand.draw")
                }
                NavigationLink(destination: DrawView(lineType: .constant(.draw)), tag: LineType.draw, selection: $selection) {
                    Label("Draw", systemImage: "scribble")
                }
            }
            .navigationTitle("Line Type")
            Text("Select Drawing Type")
                .onAppear {
                    selection = .follow
                }
        }
        
    }
    
    
    
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView()
    }
}
