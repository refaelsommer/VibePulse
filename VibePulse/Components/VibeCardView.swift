//
//  VibeCardView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibeCardView: View {
    private struct Metrics {
        static let selectedBorderWidth: CGFloat = 2
        static let selectedShadowOpacity = 0.24
        static let defaultShadowOpacity = 0.10
        static let selectedShadowRadius: CGFloat = 18
        static let selectedShadowYOffset: CGFloat = 12
        static let selectionResponse = 0.34
        static let selectionDamping = 0.68
    }

    private let emoji: String
    private let titleText: String
    private let messageText: String
    private let isSelected: Bool

    init(emoji: String, titleText: String, messageText: String, isSelected: Bool) {
        self.emoji = emoji
        self.titleText = titleText
        self.messageText = messageText
        self.isSelected = isSelected
    }

    init(viewModel: VibeOptionViewModel, isSelected: Bool) {
        self.init(
            emoji: viewModel.emoji,
            titleText: viewModel.titleText,
            messageText: viewModel.messageText,
            isSelected: isSelected
        )
    }

    var body: some View {
        VStack {
            Text(emoji)
                .font(.largeTitle)
                .padding()
                .background(VibePulseDesign.Palette.highlight.opacity(emojiBackgroundOpacity), in: Circle())

            Spacer()

            VStack {
                Text(titleText)
                    .font(.title3.weight(.heavy))
                Text(messageText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(VibePulseDesign.Palette.primaryText.opacity(VibePulseDesign.Opacity.tertiaryText))
            }
            .multilineTextAlignment(.center)
        }
        .foregroundStyle(VibePulseDesign.Palette.primaryText)
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .background(cardBackground, in: cardShape)
        .overlay(
            cardShape
                .stroke(VibePulseDesign.Palette.highlight.opacity(borderOpacity), lineWidth: isSelected ? Metrics.selectedBorderWidth : Metrics.selectedBorderWidth / 2)
        )
        .contentShape(cardShape)
        .shadow(
            color: VibePulseDesign.Palette.shade.opacity(shadowOpacity),
            radius: isSelected ? Metrics.selectedShadowRadius : Metrics.selectedShadowRadius / 2,
            y: isSelected ? Metrics.selectedShadowYOffset : Metrics.selectedShadowYOffset / 2
        )
        .animation(.spring(response: Metrics.selectionResponse, dampingFraction: Metrics.selectionDamping), value: isSelected)
    }

    private var cardBackground: some ShapeStyle {
        VibePulseDesign.Palette.highlight.opacity(isSelected ? VibePulseDesign.Opacity.cardSelectedFill : VibePulseDesign.Opacity.cardDefaultFill)
    }

    private var emojiBackgroundOpacity: Double {
        isSelected ? VibePulseDesign.Opacity.emojiSelectedFill : VibePulseDesign.Opacity.emojiDefaultFill
    }

    private var borderOpacity: Double {
        isSelected ? VibePulseDesign.Opacity.cardSelectedBorder : VibePulseDesign.Opacity.cardDefaultBorder
    }

    private var shadowOpacity: Double {
        isSelected ? Metrics.selectedShadowOpacity : Metrics.defaultShadowOpacity
    }

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: VibePulseDesign.Radius.card, style: .continuous)
    }
}
