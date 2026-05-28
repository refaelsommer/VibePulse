//
//  VibeCardView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibeCardView: View {
    private struct Metrics {
        static let contentSpacing: CGFloat = 10
        static let emojiFontSize: CGFloat = 34
        static let emojiCircleSize: CGFloat = 50
        static let selectedEmojiBackgroundOpacity = 0.28
        static let defaultEmojiBackgroundOpacity = 0.15
        static let labelSpacing: CGFloat = 3
        static let messageOpacity = 0.68
        static let minCardHeight: CGFloat = 112
        static let cardPadding: CGFloat = 14
        static let cardCornerRadius: CGFloat = 22
        static let selectedCardBackgroundOpacity = 0.26
        static let defaultCardBackgroundOpacity = 0.13
        static let selectedBorderOpacity = 0.82
        static let defaultBorderOpacity = 0.18
        static let selectedBorderWidth: CGFloat = 2
        static let defaultBorderWidth: CGFloat = 1
        static let selectedScale = 1.04
        static let defaultScale = 1.0
        static let selectedShadowOpacity = 0.24
        static let defaultShadowOpacity = 0.10
        static let selectedShadowRadius: CGFloat = 18
        static let defaultShadowRadius: CGFloat = 8
        static let selectedShadowYOffset: CGFloat = 12
        static let defaultShadowYOffset: CGFloat = 5
        static let selectionResponse = 0.34
        static let selectionDamping = 0.68
    }

    let viewModel: VibeOptionViewModel
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            Text(viewModel.emoji)
                .font(.system(size: Metrics.emojiFontSize))
                .frame(width: Metrics.emojiCircleSize, height: Metrics.emojiCircleSize)
                .background(.white.opacity(isSelected ? Metrics.selectedEmojiBackgroundOpacity : Metrics.defaultEmojiBackgroundOpacity), in: Circle())

            VStack(alignment: .leading, spacing: Metrics.labelSpacing) {
                Text(viewModel.titleText)
                    .font(.title3.weight(.heavy))
                Text(viewModel.messageText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(Metrics.messageOpacity))
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, minHeight: Metrics.minCardHeight, alignment: .leading)
        .padding(Metrics.cardPadding)
        .background(.white.opacity(isSelected ? Metrics.selectedCardBackgroundOpacity : Metrics.defaultCardBackgroundOpacity), in: RoundedRectangle(cornerRadius: Metrics.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardCornerRadius, style: .continuous)
                .stroke(.white.opacity(isSelected ? Metrics.selectedBorderOpacity : Metrics.defaultBorderOpacity), lineWidth: isSelected ? Metrics.selectedBorderWidth : Metrics.defaultBorderWidth)
        )
        .scaleEffect(isSelected ? Metrics.selectedScale : Metrics.defaultScale)
        .shadow(
            color: .black.opacity(isSelected ? Metrics.selectedShadowOpacity : Metrics.defaultShadowOpacity),
            radius: isSelected ? Metrics.selectedShadowRadius : Metrics.defaultShadowRadius,
            y: isSelected ? Metrics.selectedShadowYOffset : Metrics.defaultShadowYOffset
        )
        .animation(.spring(response: Metrics.selectionResponse, dampingFraction: Metrics.selectionDamping), value: isSelected)
    }
}
