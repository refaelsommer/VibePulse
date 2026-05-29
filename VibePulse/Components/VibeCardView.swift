//
//  VibeCardView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibeCardView: View {
    private struct Metrics {
        static let selectedEmojiBackgroundOpacity = 0.28
        static let defaultEmojiBackgroundOpacity = 0.15
        static let messageOpacity = 0.68
        static let cardCornerRadius: CGFloat = 22
        static let selectedCardBackgroundOpacity = 0.26
        static let defaultCardBackgroundOpacity = 0.13
        static let selectedBorderOpacity = 0.82
        static let defaultBorderOpacity = 0.18
        static let selectedBorderWidth: CGFloat = 2
        static let selectedShadowOpacity = 0.24
        static let defaultShadowOpacity = 0.10
        static let selectedShadowRadius: CGFloat = 18
        static let selectedShadowYOffset: CGFloat = 12
        static let selectionResponse = 0.34
        static let selectionDamping = 0.68
    }

    let emoji: String
    let titleText: String
    let messageText: String
    let isSelected: Bool

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
                .background(.white.opacity(isSelected ? Metrics.selectedEmojiBackgroundOpacity : Metrics.defaultEmojiBackgroundOpacity), in: Circle())

            Spacer()

            VStack {
                Text(titleText)
                    .font(.title3.weight(.heavy))
                Text(messageText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(Metrics.messageOpacity))
            }
            .multilineTextAlignment(.center)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .background(cardBackground, in: cardShape)
        .overlay(
            cardShape
                .stroke(.white.opacity(borderOpacity), lineWidth: isSelected ? Metrics.selectedBorderWidth : Metrics.selectedBorderWidth / 2)
        )
        .contentShape(cardShape)
        .shadow(
            color: .black.opacity(shadowOpacity),
            radius: isSelected ? Metrics.selectedShadowRadius : Metrics.selectedShadowRadius / 2,
            y: isSelected ? Metrics.selectedShadowYOffset : Metrics.selectedShadowYOffset / 2
        )
        .animation(.spring(response: Metrics.selectionResponse, dampingFraction: Metrics.selectionDamping), value: isSelected)
    }

    private var cardBackground: some ShapeStyle {
        .white.opacity(isSelected ? Metrics.selectedCardBackgroundOpacity : Metrics.defaultCardBackgroundOpacity)
    }

    private var borderOpacity: Double {
        isSelected ? Metrics.selectedBorderOpacity : Metrics.defaultBorderOpacity
    }

    private var shadowOpacity: Double {
        isSelected ? Metrics.selectedShadowOpacity : Metrics.defaultShadowOpacity
    }

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: Metrics.cardCornerRadius, style: .continuous)
    }
}
