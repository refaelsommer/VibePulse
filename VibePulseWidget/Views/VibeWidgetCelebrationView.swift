//
//  VibeWidgetCelebrationView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibeWidgetCelebrationView: View {
    private struct Metrics {
        static let particleCount = 104
        static let particleWidths: [CGFloat] = [4, 5, 7, 3]
        static let particleHeights: [CGFloat] = [10, 13, 8, 6]
        static let baseParticleOpacity = 0.7
        static let particleOpacityStep = 0.06
        static let particleOpacityCycle = 4
        static let offscreenPadding: CGFloat = 28
        static let xStepMultiplier = 37
        static let delayStepMultiplier = 23
        static let windStepMultiplier = 17
        static let positionModulo = 100
        static let rotationIndexMultiplier = 31.0
        static let rotationPhaseMultiplier = 42.0
        static let windAmplitude: CGFloat = 10
        static let windPhaseMultiplier = 0.7
        static let fallFrameCount = 15.0
        static let animationDuration = 0.95
    }

    private let entry: VibeWidgetEntry

    init(entry: VibeWidgetEntry) {
        self.entry = entry
    }

    var body: some View {
        if entry.isCelebrationFrame {
            GeometryReader { proxy in
                ForEach(0..<Metrics.particleCount, id: \.self) { index in
                    confettiPiece(for: index)
                        .position(particlePosition(for: index, in: proxy.size))
                        .opacity(particleOpacity(for: index))
                        .animation(
                            .linear(duration: Metrics.animationDuration),
                            value: entry.phase
                        )
                }
            }
        }
    }

    private func confettiPiece(for index: Int) -> some View {
        let color = VibePulseDesign.Palette.paperConfetti[index % VibePulseDesign.Palette.paperConfetti.count]
        let width = Metrics.particleWidths[index % Metrics.particleWidths.count]
        let height = Metrics.particleHeights[index % Metrics.particleHeights.count]
        let rotation = Double(index) * Metrics.rotationIndexMultiplier + Double(entry.phase) * Metrics.rotationPhaseMultiplier

        return RoundedRectangle(cornerRadius: VibePulseDesign.Radius.confetti, style: .continuous)
            .fill(color)
            .frame(width: width, height: height)
            .rotationEffect(.degrees(rotation))
    }

    private func particlePosition(for index: Int, in size: CGSize) -> CGPoint {
        let xRatio = ratio(for: index, multiplier: Metrics.xStepMultiplier)
        let windRatio = ratio(for: index, multiplier: Metrics.windStepMultiplier)
        let progress = fallProgress(for: index)
        let travelHeight = size.height + Metrics.offscreenPadding * 2
        let wind = sin(Double(entry.phase) * Metrics.windPhaseMultiplier + Double(index)) * Metrics.windAmplitude
        let stableWindOffset = Metrics.windAmplitude * (windRatio - 0.5)

        return CGPoint(
            x: size.width * xRatio + stableWindOffset + wind,
            y: -Metrics.offscreenPadding + travelHeight * progress
        )
    }

    private func particleOpacity(for index: Int) -> Double {
        let progress = fallProgress(for: index)
        guard progress >= .zero, progress <= 1 else { return .zero }
        return Metrics.baseParticleOpacity + Double(index % Metrics.particleOpacityCycle) * Metrics.particleOpacityStep
    }

    private func fallProgress(for index: Int) -> Double {
        let delayRatio = ratio(for: index, multiplier: Metrics.delayStepMultiplier)
        let startFrame = Double(delayRatio) * (Double(AppConfig.Widget.celebrationFrameCount) + Metrics.fallFrameCount) - Metrics.fallFrameCount
        return (Double(entry.phase) - startFrame) / Metrics.fallFrameCount
    }

    private func ratio(for index: Int, multiplier: Int) -> CGFloat {
        let wrappedValue = index * multiplier % Metrics.positionModulo
        return CGFloat(wrappedValue) / CGFloat(Metrics.positionModulo)
    }
}
