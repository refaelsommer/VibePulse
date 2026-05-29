//
//  VibeWidgetCelebrationView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibeWidgetCelebrationView: View {
    private struct Metrics {
        static let particleCount = 34
        static let particleWidths: [CGFloat] = [4, 5, 6, 3]
        static let particleHeights: [CGFloat] = [10, 12, 8, 6]
        static let baseParticleOpacity = 0.58
        static let particleOpacityStep = 0.08
        static let particleOpacityCycle = 4
        static let edgeInsetRatio: CGFloat = 0.08
        static let usableAreaRatio: CGFloat = 0.84
        static let xStepMultiplier = 37
        static let xPhaseMultiplier = 19
        static let yStepMultiplier = 53
        static let yPhaseMultiplier = 23
        static let positionModulo = 100
        static let rotationIndexMultiplier = 31.0
        static let rotationPhaseMultiplier = 24.0
    }

    let entry: VibeWidgetEntry

    var body: some View {
        if entry.isCelebrationFrame {
            GeometryReader { proxy in
                ForEach(0..<Metrics.particleCount, id: \.self) { index in
                    confettiPiece(for: index)
                        .position(
                            x: xPosition(for: index, width: proxy.size.width),
                            y: yPosition(for: index, height: proxy.size.height)
                        )
                }
            }
        }
    }

    private func confettiPiece(for index: Int) -> some View {
        let color = VibePulseDesign.Palette.paperConfetti[index % VibePulseDesign.Palette.paperConfetti.count]
        let width = Metrics.particleWidths[index % Metrics.particleWidths.count]
        let height = Metrics.particleHeights[index % Metrics.particleHeights.count]
        let opacity = Metrics.baseParticleOpacity + Double((index + entry.phase) % Metrics.particleOpacityCycle) * Metrics.particleOpacityStep
        let rotation = Double(index) * Metrics.rotationIndexMultiplier + Double(entry.phase) * Metrics.rotationPhaseMultiplier

        return RoundedRectangle(cornerRadius: VibePulseDesign.Radius.confetti, style: .continuous)
            .fill(color)
            .frame(width: width, height: height)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
    }

    private func xPosition(for index: Int, width: CGFloat) -> CGFloat {
        let ratio = placementRatio(
            for: index,
            indexMultiplier: Metrics.xStepMultiplier,
            phaseMultiplier: Metrics.xPhaseMultiplier
        )
        return width * (Metrics.edgeInsetRatio + ratio * Metrics.usableAreaRatio)
    }

    private func yPosition(for index: Int, height: CGFloat) -> CGFloat {
        let ratio = placementRatio(
            for: index,
            indexMultiplier: Metrics.yStepMultiplier,
            phaseMultiplier: Metrics.yPhaseMultiplier
        )
        return height * (Metrics.edgeInsetRatio + ratio * Metrics.usableAreaRatio)
    }

    private func placementRatio(for index: Int, indexMultiplier: Int, phaseMultiplier: Int) -> CGFloat {
        let shiftedValue = index * indexMultiplier + entry.phase * phaseMultiplier
        let wrappedValue = shiftedValue % Metrics.positionModulo
        return CGFloat(wrappedValue) / CGFloat(Metrics.positionModulo)
    }
}
