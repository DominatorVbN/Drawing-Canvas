//
//  DrawView.swift
//  Drawing Canvas
//
//  Created by Amit Samant on 10/06/21.
//

import SwiftUI

enum LineType: Hashable, Equatable {
    case follow
    case draw
}

struct DrawView: View {
    
    @Binding var lineType: LineType
    @State var isPlaying: Bool = false
    @State var points: [CGPoint] = []
    @State var strokes: [[CGPoint]] = []
    @State var currentStrock = 0
    
    var visulaiser: some View {
        TimelineView(.animation) { timeContext in
            Canvas { context, size in
                let canvasPath = Path(
                    CGRect(
                        x: 0,
                        y: 0,
                        width: size.width,
                        height: size.height
                    )
                )
                if isPlaying {
                    context.opacity = 0.2
                    context.blendMode = .colorDodge
                    let firstGradient = context
                    let y = cos(timeContext.date.timeIntervalSinceReferenceDate)
                    firstGradient.fill(
                        canvasPath,
                        with: .linearGradient(
                            .init(
                                colors: [.teal,.pink]),
                            startPoint: CGPoint(
                                x: (2 * y) * size.height ,
                                y: (2 * y) * size.height),
                            endPoint: CGPoint(
                                x: -max((2 * y), 0.5) * size.width,
                                y:  -(2 * y) * size.height
                            )
                        )
                    )
                    firstGradient.fill(
                        canvasPath,
                        with: .linearGradient(
                            .init(
                                colors: [.red,.blue]),
                            startPoint: CGPoint(
                                x: 0,
                                y: -(2 * y) * size.height
                            ),
                            endPoint: CGPoint(
                                x: size.width,
                                y:  (2 * y) * size.height
                            )
                        )
                    )
                    firstGradient.fill(
                        canvasPath,
                        with: .linearGradient(
                            .init(colors: [.blue,.teal]),
                            startPoint: CGPoint(
                                x: (2 * y) * size.width,
                                y: 0
                            ),
                            endPoint: CGPoint(
                                x: -(2 * y) * size.width,
                                y:  size.height
                            )
                        )
                    )
                    firstGradient.fill(
                        canvasPath,
                        with: .linearGradient(
                            .init(colors: [.brown,.clear]),
                            startPoint: CGPoint(x: -(2 * y) * size.width, y: 0),
                            endPoint: CGPoint(
                                x: (2 * y) * size.width,
                                y:  size.height
                            )
                        )
                    )
                    firstGradient.fill(
                        canvasPath,
                        with: .linearGradient(
                            .init(colors: [.red,.blue]),
                            startPoint: CGPoint(
                                x: 0,
                                y: -(2 * y) * size.height),
                            endPoint: CGPoint(
                                x: size.width,
                                y:  (2 * y) * size.height
                            )
                        )
                    )
                } else {
                    context.fill(
                        canvasPath,
                        with: .linearGradient(
                            .init(colors: [.teal, .blue]),
                            startPoint: .init(
                                x: 0,
                                y: 0.5 * size.height
                            ),
                            endPoint: .init(
                                x: size.width,
                                y: 0.5 * size.height
                            )
                        )
                    )
                }
                
                let path: Path
                switch lineType {
                case .follow:
                    path = Path { path in
                        guard points.count >= 2 else {
                            return
                        }
                        path.move(to: points[0])
                        path.addLines(Array(points[1..<points.count]))
                    }
                case .draw:
                    path = Path { path in
                        for strok in strokes {
                            guard strok.count >= 2 else {
                                continue
                            }
                            path.move(to: strok[0])
                            path.addLines(Array(strok[1..<strok.count]))
                        }
                    }
                }
                context.opacity = 0.8
                context.blendMode = .colorDodge
                context.stroke(
                    path,
                    with: .backdrop,
                    style: .init(
                        lineWidth: 10,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .gesture(
            DragGesture(minimumDistance: 0).onChanged { value in
            switch lineType {
            case .follow:
                if points.count > 10 {
                    points.remove(at: 0)
                }
                points.append(value.location)
            case .draw:
                if currentStrock < strokes.count {
                    strokes[currentStrock].append(value.location)
                } else {
                    strokes.append([value.location])
                }
            }
        }.onEnded { _ in
            switch lineType {
            case .follow:
                Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
                    if points.count > 0 {
                        points.remove(at: 0)
                    } else {
                        timer.invalidate()
                    }
                }
            case .draw:
                currentStrock += 1
            }
        }
        )
    }
    
    var body: some View {
        visulaiser
            .navigationTitle("Drawing Canvas")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                }
#else
                ToolbarItem(placement: .navigation) {
                    Toggle(isOn: $isPlaying) {
                        Image(systemName: "play.fill")
                    }
                }
#endif
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        clear()
                    } label: {
                        Label("Clear", systemImage: "trash")
                    }
                }
            }
    }
    
    func clear() {
        points = []
        strokes = []
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView(lineType: .constant(.follow))
    }
}
