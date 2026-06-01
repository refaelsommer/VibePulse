//
//  VibeWidgetCelebrationView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibeWidgetCelebrationView: View {
    private struct Metrics {
        static let particleCount = 240
        static let particleWidths: [CGFloat] = [5, 6, 8, 4]
        static let particleHeights: [CGFloat] = [12, 15, 10, 8]
        static let baseParticleOpacity = 0.7
        static let particleOpacityStep = 0.06
        static let particleOpacityCycle = 4
        static let offscreenPadding: CGFloat = 28
        static let xStepMultiplier = 37
        static let delayStepMultiplier = 23
        static let windStepMultiplier = 17
        static let colorStepMultiplier = 29
        static let hashCurveMultiplier = 11
        static let positionModulo = 997
        static let horizontalLaneCount = 7
        static let horizontalLaneInsetRatio: CGFloat = 0.04
        static let horizontalUsableRatio: CGFloat = 0.92
        static let rotationIndexMultiplier = 31.0
        static let rotationPhaseMultiplier = 42.0
        static let windAmplitude: CGFloat = 10
        static let windPhaseMultiplier = 0.7
        static let fallFrameCount = 7.0
        static let initialEmptyFrameCount = 3.0
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
        let color = VibePulseDesign.Palette.paperConfetti[colorIndex(for: index)]
        let width = Metrics.particleWidths[index % Metrics.particleWidths.count]
        let height = Metrics.particleHeights[index % Metrics.particleHeights.count]
        let rotation = Double(index) * Metrics.rotationIndexMultiplier + Double(entry.phase) * Metrics.rotationPhaseMultiplier

        return RoundedRectangle(cornerRadius: VibePulseDesign.Radius.confetti, style: .continuous)
            .fill(color)
            .frame(width: width, height: height)
            .rotationEffect(.degrees(rotation))
    }

    private func particlePosition(for index: Int, in size: CGSize) -> CGPoint {
        let xRatio = horizontalRatio(for: index)
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

    private func horizontalRatio(for index: Int) -> CGFloat {
        let lane = index % Metrics.horizontalLaneCount
        let laneProgress = (CGFloat(lane) + 0.5) / CGFloat(Metrics.horizontalLaneCount)
        let jitter = ratio(for: index, multiplier: Metrics.xStepMultiplier) - 0.5
        let laneWidth = 1 / CGFloat(Metrics.horizontalLaneCount)
        let scatteredLaneProgress = laneProgress + jitter * laneWidth

        return Metrics.horizontalLaneInsetRatio + scatteredLaneProgress * Metrics.horizontalUsableRatio
    }

    private func particleOpacity(for index: Int) -> Double {
        let progress = fallProgress(for: index)
        guard progress >= .zero, progress <= 1 else { return .zero }
        return Metrics.baseParticleOpacity + Double(index % Metrics.particleOpacityCycle) * Metrics.particleOpacityStep
    }

    private func fallProgress(for index: Int) -> Double {
        let delayRatio = ratio(for: index, multiplier: Metrics.delayStepMultiplier)
        let availableStartFrames = max(
            1,
            Double(AppConfig.Widget.celebrationFrameCount) - Metrics.fallFrameCount - Metrics.initialEmptyFrameCount
        )
        let startFrame = Metrics.initialEmptyFrameCount + Double(delayRatio) * availableStartFrames
        return (Double(entry.phase) - startFrame) / Metrics.fallFrameCount
    }

    private func ratio(for index: Int, multiplier: Int) -> CGFloat {
        let curvedIndex = index * index * Metrics.hashCurveMultiplier
        let wrappedValue = (index * multiplier + curvedIndex) % Metrics.positionModulo
        return CGFloat(wrappedValue) / CGFloat(Metrics.positionModulo)
    }

    private func colorIndex(for index: Int) -> Int {
        let colorCount = VibePulseDesign.Palette.paperConfetti.count
        let curvedIndex = index * index * Metrics.hashCurveMultiplier
        return (index * Metrics.colorStepMultiplier + curvedIndex) % colorCount
    }
}
