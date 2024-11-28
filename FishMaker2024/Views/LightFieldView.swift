//
//  LightFieldView.swift
//  FishMaker2024
//
//  Created by Anthony Heath on 11/27/24.
//

import SwiftUI

struct LightFieldView: View {
    @StateObject private var viewModel = LightFieldViewModel()
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            if let image = viewModel.displayImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay(LensletGridOverlay())
                    .scaleEffect(currentScale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                let newScale = currentScale * delta
                                currentScale = min(max(newScale, 0.5), 5.0)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            }
                    )
            } else {
                Text("No image loaded")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        Button("Load Test Image") {
            viewModel.loadTestImage()
        }
        .padding()
    }
}

struct LensletGridOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let xOffset: CGFloat = 8
                let yOffset: CGFloat = 29
                
                let scaleX = geometry.size.width / CGFloat(LightFieldParameters.imageWidth)
                let scaleY = geometry.size.height / CGFloat(LightFieldParameters.imageHeight)
                
                let viewXOffset = xOffset * scaleX
                let viewYOffset = yOffset * scaleY
                
                // Using more precise measurements
                let pixelsPerLensletX: CGFloat = 57.5  // 4600/80
                let pixelsPerLensletY: CGFloat = 57.1  // 3427/60
                
                let stepX = pixelsPerLensletX * scaleX
                let stepY = pixelsPerLensletY * scaleY
                
                // Vertical lines
                for i in 0...LightFieldParameters.visibleArrayWidth {
                    let x = viewXOffset + (stepX * CGFloat(i))
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                // Horizontal lines
                for i in 0...LightFieldParameters.visibleArrayHeight {
                    let y = viewYOffset + (stepY * CGFloat(i))
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.green, lineWidth: 0.5)
        }
    }
}
