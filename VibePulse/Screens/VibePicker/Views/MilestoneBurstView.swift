//
//  MilestoneBurstView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct MilestoneBurstView: View {
    private struct Metrics {
        static let overlayOpacity = 0.42
        static let particleCount = 22
        static let particleSymbols = ["✨", "⚡️", "🌈", "🔥", "💫"]
        static let particleBaseSize: CGFloat = 22
        static let particleSizeStep: CGFloat = 8
        static let particleSizeCycle = 4
        static let particleOrbitRadiusX: CGFloat = 196
        static let particleOrbitRadiusY: CGFloat = 158
        static let particleAngleOffsetDegrees = -18.0
        static let particleSpinDegrees = 24.0
        static let orbitStartDegrees = 0.0
        static let orbitEndDegrees = 360.0
        static let orbitDuration = 1.15
        static let orbitDelay = 0.08
        static let hiddenParticleOpacity = 0.0
        static let visibleParticleOpacity = 1.0
        static let hiddenParticleScale = 0.28
        static let visibleParticleScale = 1.0
        static let contentSpacing: CGFloat = 14
        static let streakNumberFontSize: CGFloat = 86
        static let subtitleOpacity = 0.72
        static let contentPadding: CGFloat = 30
        static let contentCornerRadius: CGFloat = 32
        static let buttonTopPadding: CGFloat = 10
        static let buttonHorizontalPadding: CGFloat = 20
        static let buttonVerticalPadding: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 18
        static let buttonBackgroundOpacity = 0.22
        static let buttonBorderOpacity = 0.3
        static let buttonBorderWidth: CGFloat = 1
        static let expandedScale = 1.0
        static let collapsedScale = 0.72
        static let burstResponse = 0.55
        static let burstDamping = 0.62
    }

    let viewModel: MilestoneBurstViewModel
    let dismiss: () -> Void
    @State private var pop = false
    @State private var orbitDegrees = Metrics.orbitStartDegrees

    var body: some View {
        ZStack {
            Color.black.opacity(Metrics.overlayOpacity).ignoresSafeArea()

            orbitingParticles

            VStack(spacing: Metrics.contentSpacing) {
                Text(viewModel.streakNumberText)
                    .font(.system(size: Metrics.streakNumberFontSize, weight: .black, design: .rounded))
                Text(viewModel.titleText)
                    .font(.title.weight(.heavy))
                Text(viewModel.subtitleText)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(Metrics.subtitleOpacity))

                Button(action: dismiss) {
                    Text(viewModel.confirmationButtonText)
                        .font(.headline.weight(.bold))
                        .padding(.horizontal, Metrics.buttonHorizontalPadding)
                        .padding(.vertical, Metrics.buttonVerticalPadding)
                        .background(.white.opacity(Metrics.buttonBackgroundOpacity), in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(Metrics.buttonBorderOpacity), lineWidth: Metrics.buttonBorderWidth)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, Metrics.buttonTopPadding)
            }
            .foregroundStyle(.white)
            .padding(Metrics.contentPadding)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Metrics.contentCornerRadius, style: .continuous))
            .scaleEffect(pop ? Metrics.expandedScale : Metrics.collapsedScale)
        }
        .onAppear {
            withAnimation(.spring(response: Metrics.burstResponse, dampingFraction: Metrics.burstDamping)) {
                pop = true
            }
            withAnimation(.easeInOut(duration: Metrics.orbitDuration).delay(Metrics.orbitDelay)) {
                orbitDegrees = Metrics.orbitEndDegrees
            }
        }
    }

    private var orbitingParticles: some View {
        ZStack {
            ForEach(0..<Metrics.particleCount, id: \.self) { index in
                let angle = particleAngle(for: index)

                Text(Metrics.particleSymbols[index % Metrics.particleSymbols.count])
                    .font(.system(size: particleSize(for: index)))
                    .offset(x: cos(angle) * Metrics.particleOrbitRadiusX, y: sin(angle) * Metrics.particleOrbitRadiusY)
                    .rotationEffect(.degrees(Double(index) * Metrics.particleSpinDegrees))
            }
        }
        .rotationEffect(.degrees(orbitDegrees))
        .scaleEffect(pop ? Metrics.visibleParticleScale : Metrics.hiddenParticleScale)
        .opacity(pop ? Metrics.visibleParticleOpacity : Metrics.hiddenParticleOpacity)
        .allowsHitTesting(false)
    }

    private func particleAngle(for index: Int) -> CGFloat {
        let progress = Double(index) / Double(Metrics.particleCount)
        let degrees = progress * Metrics.orbitEndDegrees + Metrics.particleAngleOffsetDegrees
        return CGFloat(degrees * .pi / 180)
    }

    private func particleSize(for index: Int) -> CGFloat {
        Metrics.particleBaseSize + CGFloat(index % Metrics.particleSizeCycle) * Metrics.particleSizeStep
    }
}
