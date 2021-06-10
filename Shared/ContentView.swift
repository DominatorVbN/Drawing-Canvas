//
//  ContentView.swift
//  Shared
//
//  Created by Amit Samant on 10/06/21.
//

import SwiftUI

struct ContentView: View {
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            SegmentedView()
        } else {
            SideBarView()
        }
        #else
        SideBarView()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
