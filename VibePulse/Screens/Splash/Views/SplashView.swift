//
//  SplashView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct SplashView: View {
    private struct Metrics {
        static let animationDuration = 1.45
        static let handoffDelay = 1.65
        static let exitDuration = 0.28
        static let pulseOrbSize: CGFloat = 118
        static let pulseRingSize: CGFloat = 168
        static let expandedRingScale = 1.2
        static let collapsedRingScale = 0.7
        static let expandedParticleScale = 1.0
        static let collapsedParticleScale = 0.35
        static let titleFontSize: CGFloat = 44
        static let titleTopPadding: CGFloat = 118
        static let taglineTopPadding: CGFloat = 4
        static let glowSize: CGFloat = 310
        static let glowOpacity = 0.34
        static let glowBlur: CGFloat = 34
        static let ringLineWidth: CGFloat = 2
        static let ringOpacity = 0.52
        static let particleShadowRadius: CGFloat = 10
        static let particleShadowOpacity = 0.38
    }

    private let viewModel: SplashViewModel
    private let onFinished: () -> Void

    @State private var didAnimate = false
    @State private var isExiting = false

    init(viewModel: SplashViewModel, onFinished: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onFinished = onFinished
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: VibePulseDesign.Palette.splashBackground, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Circle()
                .fill(VibePulseDesign.Palette.highlight.opacity(Metrics.glowOpacity))
                .frame(width: Metrics.glowSize, height: Metrics.glowSize)
                .blur(radius: Metrics.glowBlur)
                .scaleEffect(didAnimate ? Metrics.expandedRingScale : Metrics.collapsedRingScale)

            VStack {
                Spacer()

                ZStack {
                    Circle()
                        .stroke(VibePulseDesign.Palette.highlight.opacity(Metrics.ringOpacity), lineWidth: Metrics.ringLineWidth)
                        .frame(width: Metrics.pulseRingSize, height: Metrics.pulseRingSize)
                        .scaleEffect(didAnimate ? Metrics.expandedRingScale : Metrics.collapsedRingScale)

                    ForEach(viewModel.particles) { particle in
                        Text(particle.symbol)
                            .font(.system(size: particle.size))
                            .shadow(color: particle.color.opacity(Metrics.particleShadowOpacity), radius: Metrics.particleShadowRadius)
                            .offset(didAnimate ? particleOffset(for: particle) : .zero)
                            .scaleEffect(didAnimate ? Metrics.expandedParticleScale : Metrics.collapsedParticleScale)
                    }

                    Circle()
                        .fill(AngularGradient(colors: VibePulseDesign.Palette.pulseOrb, center: .center))
                        .frame(width: Metrics.pulseOrbSize, height: Metrics.pulseOrbSize)
                        .rotationEffect(.degrees(didAnimate ? 360 : 0))
                        .overlay {
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 46, weight: .black))
                                .foregroundStyle(VibePulseDesign.Palette.primaryText)
                        }
                }

                Text(viewModel.appNameText)
                    .font(.system(size: Metrics.titleFontSize, weight: .black, design: .rounded))
                    .foregroundStyle(VibePulseDesign.Palette.primaryText)
                    .padding(.top, Metrics.titleTopPadding)

                Text(viewModel.taglineText)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(VibePulseDesign.Palette.primaryText.opacity(VibePulseDesign.Opacity.subduedText))
                    .padding(.top, Metrics.taglineTopPadding)

                Spacer()
            }
        }
        .opacity(isExiting ? .zero : 1)
        .scaleEffect(isExiting ? Metrics.expandedRingScale : 1)
        .onAppear {
            withAnimation(.easeInOut(duration: Metrics.animationDuration)) {
                didAnimate = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + Metrics.handoffDelay) {
                withAnimation(.easeInOut(duration: Metrics.exitDuration)) {
                    isExiting = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Metrics.exitDuration) {
                    onFinished()
                }
            }
        }
    }

    private func particleOffset(for particle: SplashParticle) -> CGSize {
        CGSize(
            width: cos(particle.angle.radians) * particle.radius,
            height: sin(particle.angle.radians) * particle.radius
        )
    }
}
