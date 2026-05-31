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
        static let orbitRadius: CGFloat = 166
        static let orbitDuration = 7.0
        static let orbitDelay = 0.08
        static let hiddenScale = 0.28
        static let fullCircleRadians = 2 * Double.pi
        static let topAngleOffsetRadians = -Double.pi / 2
    }

    private let isVisible: Bool
    @State private var orbitAngle = Angle.zero

    init(isVisible: Bool) {
        self.isVisible = isVisible
    }

    private var orbitSymbols: [String] {
        Vibe.allCases.map(\.emoji)
    }

    var body: some View {
        ZStack {
            ForEach(orbitSymbols.indices, id: \.self) { index in
                let angle = particleAngle(for: index)

                Text(orbitSymbols[index])
                    .font(.system(size: Metrics.emojiSize))
                    .offset(x: cos(angle) * Metrics.orbitRadius, y: sin(angle) * Metrics.orbitRadius)
            }
        }
        .rotationEffect(orbitAngle)
        .scaleEffect(isVisible ? 1 : Metrics.hiddenScale)
        .opacity(isVisible ? 1 : .zero)
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.linear(duration: Metrics.orbitDuration).delay(Metrics.orbitDelay).repeatForever(autoreverses: false)) {
                orbitAngle = .degrees(360)
            }
        }
    }

    private func particleAngle(for index: Int) -> CGFloat {
        let progress = Double(index) / Double(orbitSymbols.count)
        return CGFloat(Metrics.fullCircleRadians * progress + Metrics.topAngleOffsetRadians)
    }
}
