//
//  EmojiOrbitView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct EmojiOrbitView: View {
    private struct Metrics {
        static let emojiSize: CGFloat = 34
        static let orbitRadiusX: CGFloat = 190
        static let orbitRadiusY: CGFloat = 146
        static let angleOffsetDegrees = -90.0
        static let orbitStartDegrees = 0.0
        static let orbitEndDegrees = 360.0
        static let orbitDuration = 7.0
        static let orbitDelay = 0.08
        static let hiddenOpacity = 0.0
        static let visibleOpacity = 1.0
        static let hiddenScale = 0.28
        static let visibleScale = 1.0
    }

    let isVisible: Bool
    @State private var orbitDegrees = Metrics.orbitStartDegrees

    private var orbitSymbols: [String] {
        Vibe.allCases.map(\.emoji)
    }

    var body: some View {
        ZStack {
            ForEach(orbitSymbols.indices, id: \.self) { index in
                let angle = particleAngle(for: index)

                Text(orbitSymbols[index])
                    .font(.system(size: Metrics.emojiSize))
                    .offset(x: cos(angle) * Metrics.orbitRadiusX, y: sin(angle) * Metrics.orbitRadiusY)
            }
        }
        .rotationEffect(.degrees(orbitDegrees))
        .scaleEffect(isVisible ? Metrics.visibleScale : Metrics.hiddenScale)
        .opacity(isVisible ? Metrics.visibleOpacity : Metrics.hiddenOpacity)
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.linear(duration: Metrics.orbitDuration).delay(Metrics.orbitDelay).repeatForever(autoreverses: false)) {
                orbitDegrees = Metrics.orbitEndDegrees
            }
        }
    }

    private func particleAngle(for index: Int) -> CGFloat {
        let progress = Double(index) / Double(orbitSymbols.count)
        let degrees = progress * 360.0 + Metrics.angleOffsetDegrees
        return CGFloat(degrees * .pi / 180)
    }
}
