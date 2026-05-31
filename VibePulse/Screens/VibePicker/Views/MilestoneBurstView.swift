//
//  MilestoneBurstView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct MilestoneBurstView: View {
    private struct Metrics {
        static let contentSpacing: CGFloat = 14
        static let streakNumberFontSize: CGFloat = 86
        static let contentPadding: CGFloat = 30
        static let buttonTopPadding: CGFloat = 10
        static let buttonHorizontalPadding: CGFloat = 20
        static let buttonVerticalPadding: CGFloat = 12
        static let buttonBorderOpacity = 0.3
        static let buttonBorderWidth: CGFloat = 1
        static let expandedScale = 1.0
        static let collapsedScale = 0.72
        static let burstResponse = 0.55
        static let burstDamping = 0.62
    }

    private let viewModel: MilestoneBurstViewModel
    private let dismiss: () -> Void
    @State private var pop = false

    init(viewModel: MilestoneBurstViewModel, dismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismiss = dismiss
    }

    var body: some View {
        ZStack {
            VibePulseDesign.Palette.shade.opacity(VibePulseDesign.Opacity.scrim).ignoresSafeArea()

            ConfettiBurstView()
                .zIndex(3)

            VStack(spacing: Metrics.contentSpacing) {
                Text(viewModel.streakNumberText)
                    .font(.system(size: Metrics.streakNumberFontSize, weight: .black, design: .rounded))
                Text(viewModel.titleText)
                    .font(.title.weight(.heavy))
                Text(viewModel.subtitleText)
                    .font(.headline)
                    .foregroundStyle(VibePulseDesign.Palette.primaryText.opacity(VibePulseDesign.Opacity.subduedText))

                Button(action: dismiss) {
                    Text(viewModel.confirmationButtonText)
                        .font(.headline.weight(.bold))
                        .padding(.horizontal, Metrics.buttonHorizontalPadding)
                        .padding(.vertical, Metrics.buttonVerticalPadding)
                        .background(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.capsuleFill), in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(VibePulseDesign.Palette.highlight.opacity(Metrics.buttonBorderOpacity), lineWidth: Metrics.buttonBorderWidth)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, Metrics.buttonTopPadding)
            }
            .foregroundStyle(VibePulseDesign.Palette.primaryText)
            .padding(Metrics.contentPadding)
            .background(VibePulseDesign.MaterialStyle.panel, in: RoundedRectangle(cornerRadius: VibePulseDesign.Radius.modal, style: .continuous))
            .scaleEffect(pop ? Metrics.expandedScale : Metrics.collapsedScale)
            .zIndex(1)

            EmojiOrbitView(isVisible: pop)
                .zIndex(2)
        }
        .onAppear {
            withAnimation(.spring(response: Metrics.burstResponse, dampingFraction: Metrics.burstDamping)) {
                pop = true
            }
        }
    }
}
