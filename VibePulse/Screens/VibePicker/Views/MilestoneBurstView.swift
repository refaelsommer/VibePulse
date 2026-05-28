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

    var body: some View {
        ZStack {
            Color.black.opacity(Metrics.overlayOpacity).ignoresSafeArea()

            MilestoneConfettiView()
                .zIndex(3)

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
            .zIndex(1)

            MilestoneOrbitView(isVisible: pop)
                .zIndex(2)
        }
        .onAppear {
            withAnimation(.spring(response: Metrics.burstResponse, dampingFraction: Metrics.burstDamping)) {
                pop = true
            }
        }
    }
}
