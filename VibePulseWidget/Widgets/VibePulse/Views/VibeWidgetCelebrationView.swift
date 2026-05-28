//
//  VibeWidgetCelebrationView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibeWidgetCelebrationView: View {
    private struct Metrics {
        static let particleCount = 10
        static let particleSymbols = ["✦", "✹", "✺", "✧"]
        static let particleBaseSize: CGFloat = 20
        static let particleSizeStep: CGFloat = 9
        static let particleSizeCycle = 3
        static let baseParticleOpacity = 0.24
        static let particleOpacityStep = 0.1
        static let particleOpacityCycle = 4
        static let xIndexMultiplier = 31
        static let xPhaseMultiplier = 34
        static let yIndexMultiplier = 47
        static let yPhaseMultiplier = 24
        static let offsetModulo: CGFloat = 170
        static let xOffsetBias: CGFloat = 48
        static let yOffsetBias: CGFloat = 42
        static let phaseScaleStep = 0.05
        static let restingScale = 1.0
    }

    let entry: VibeWidgetEntry

    var body: some View {
        if entry.isCelebrationFrame {
            ZStack {
                ForEach(0..<Metrics.particleCount, id: \.self) { index in
                    Text(Metrics.particleSymbols[index % Metrics.particleSymbols.count])
                        .font(.system(size: Metrics.particleBaseSize + CGFloat(index % Metrics.particleSizeCycle) * Metrics.particleSizeStep, weight: .heavy))
                        .foregroundStyle(.white.opacity(Metrics.baseParticleOpacity + Double((index + entry.phase) % Metrics.particleOpacityCycle) * Metrics.particleOpacityStep))
                        .offset(
                            x: CGFloat(index * Metrics.xIndexMultiplier + entry.phase * Metrics.xPhaseMultiplier).truncatingRemainder(dividingBy: Metrics.offsetModulo) - Metrics.xOffsetBias,
                            y: CGFloat(index * Metrics.yIndexMultiplier + entry.phase * Metrics.yPhaseMultiplier).truncatingRemainder(dividingBy: Metrics.offsetModulo) - Metrics.yOffsetBias
                        )
                }
            }
            .scaleEffect(Metrics.restingScale + CGFloat(entry.phase) * Metrics.phaseScaleStep)
        }
    }
}
