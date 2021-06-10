//
//  SegmentedView.swift
//  Drawing Canvas (iOS)
//
//  Created by Amit Samant on 10/06/21.
//

import SwiftUI

struct SegmentedView: View {
    @State var lineType: LineType = .follow
    
    var body: some View {
        NavigationView {
            DrawView(lineType: $lineType)
        }
        .safeAreaInset(edge: .bottom) {
            Picker("Line type", selection: $lineType) {
                Text("Follow").tag(LineType.follow)
                Text("Draw").tag(LineType.draw)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(.thinMaterial)
        }
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}
