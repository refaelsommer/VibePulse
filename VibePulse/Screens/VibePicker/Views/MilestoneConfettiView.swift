//
//  MilestoneConfettiView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct MilestoneConfettiView: View {
    private struct Metrics {
        static let particleCount = 96
        static let originXRatio: CGFloat = 0.5
        static let originYRatio: CGFloat = 0.94
        static let originSpreadX: CGFloat = 44
        static let originSpreadY: CGFloat = 18
        static let sideExitDistance: CGFloat = 96
        static let topExitDistance: CGFloat = 170
        static let horizontalExitRatio: CGFloat = 0.92
        static let sideExitTopBias: CGFloat = 150
        static let sideExitVerticalRangeRatio: CGFloat = 0.48
        static let duration = 3.4
        static let delayStep = 0.006
        static let staticRotationStep = 27.0
        static let staticRotationModulo = 9
        static let staticRotationCenter = 4.0
        static let minWidth: CGFloat = 5
        static let widthStep: CGFloat = 3
        static let widthCycle = 5
        static let baseHeight: CGFloat = 14
        static let heightStep: CGFloat = 3
        static let heightCycle = 4
        static let cornerRadius: CGFloat = 1.5
        static let hiddenOpacity = 0.0
        static let visibleOpacity = 1.0
        static let sideStepMultiplier = 7
        static let sideStepModulo = 17
        static let sideStepCenter = 8.0
        static let verticalStepMultiplier = 19
        static let verticalStepModulo = 100
        static let originXStepMultiplier = 23
        static let originXStepModulo = 100
        static let originYStepMultiplier = 31
        static let originYStepModulo = 100
        static let colors = [
            Color(red: 0.93, green: 0.05, blue: 0.12),
            Color(red: 0.06, green: 0.30, blue: 0.90),
            Color(red: 0.04, green: 0.62, blue: 0.26),
            Color(red: 1.00, green: 0.79, blue: 0.05),
            Color(red: 1.00, green: 0.36, blue: 0.02),
            Color(red: 0.00, green: 0.72, blue: 0.70),
            Color(red: 0.91, green: 0.10, blue: 0.38)
        ]
    }

    @State private var explodes = false
    @State private var isVisible = true

    var body: some View {
        if isVisible {
            GeometryReader { proxy in
                ZStack {
                    ForEach(0..<Metrics.particleCount, id: \.self) { index in
                        confettiPiece(for: index)
                            .position(originPoint(for: index, in: proxy.size))
                            .offset(explodes ? targetOffset(for: index, in: proxy.size) : .zero)
                            .rotationEffect(.degrees(staticRotationDegrees(for: index)))
                            .opacity(explodes ? Metrics.hiddenOpacity : Metrics.visibleOpacity)
                            .animation(
                                .easeOut(duration: Metrics.duration)
                                    .delay(Double(index) * Metrics.delayStep),
                                value: explodes
                            )
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .onAppear {
                explodes = true
                removeAfterAnimation()
            }
        }
    }

    private func confettiPiece(for index: Int) -> some View {
        RoundedRectangle(cornerRadius: Metrics.cornerRadius, style: .continuous)
            .fill(color(for: index))
            .frame(width: width(for: index), height: height(for: index))
    }

    private func originPoint(for index: Int, in size: CGSize) -> CGPoint {
        let xJitter = normalizedStep(index, multiplier: Metrics.originXStepMultiplier, modulo: Metrics.originXStepModulo) - 0.5
        let yJitter = normalizedStep(index, multiplier: Metrics.originYStepMultiplier, modulo: Metrics.originYStepModulo) - 0.5

        return CGPoint(
            x: size.width * Metrics.originXRatio + xJitter * Metrics.originSpreadX,
            y: size.height * Metrics.originYRatio + yJitter * Metrics.originSpreadY
        )
    }

    private func targetOffset(for index: Int, in size: CGSize) -> CGSize {
        let origin = originPoint(for: index, in: size)
        let target = targetPoint(for: index, in: size)

        return CGSize(
            width: target.x - origin.x,
            height: target.y - origin.y
        )
    }

    private func targetPoint(for index: Int, in size: CGSize) -> CGPoint {
        let side = sideDirection(for: index)
        let verticalVariation = normalizedStep(index, multiplier: Metrics.verticalStepMultiplier, modulo: Metrics.verticalStepModulo)
        let exitsThroughTop = abs(side) < 0.25
        let x: CGFloat
        let y: CGFloat

        if exitsThroughTop {
            x = size.width * Metrics.originXRatio + side * size.width * Metrics.horizontalExitRatio
            y = -Metrics.topExitDistance
        } else {
            x = side < 0 ? -Metrics.sideExitDistance : size.width + Metrics.sideExitDistance
            y = -Metrics.sideExitTopBias + verticalVariation * size.height * Metrics.sideExitVerticalRangeRatio
        }

        return CGPoint(
            x: x,
            y: y
        )
    }

    private func sideDirection(for index: Int) -> CGFloat {
        let step = Double((index * Metrics.sideStepMultiplier) % Metrics.sideStepModulo)
        return CGFloat((step - Metrics.sideStepCenter) / Metrics.sideStepCenter)
    }

    private func staticRotationDegrees(for index: Int) -> Double {
        let step = Double(index % Metrics.staticRotationModulo)
        return (step - Metrics.staticRotationCenter) * Metrics.staticRotationStep
    }

    private func removeAfterAnimation() {
        let totalDelay = Double(Metrics.particleCount - 1) * Metrics.delayStep
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(Metrics.duration + totalDelay))
            isVisible = false
        }
    }

    private func normalizedStep(_ index: Int, multiplier: Int, modulo: Int) -> CGFloat {
        CGFloat((index * multiplier) % modulo) / CGFloat(modulo)
    }

    private func color(for index: Int) -> Color {
        Metrics.colors[index % Metrics.colors.count]
    }

    private func width(for index: Int) -> CGFloat {
        Metrics.minWidth + CGFloat(index % Metrics.widthCycle) * Metrics.widthStep
    }

    private func height(for index: Int) -> CGFloat {
        Metrics.baseHeight + CGFloat(index % Metrics.heightCycle) * Metrics.heightStep
    }
}
