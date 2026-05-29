//
//  VibePulseDesign.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

enum VibePulseDesign {
    enum Palette {
        static let primaryText = Color.white
        static let shade = Color.black
        static let clearShade = Color.black.opacity(.zero)
        static let highlight = Color.white

        static let defaultBackground = [
            Color(red: 0.07, green: 0.08, blue: 0.12),
            Color(red: 0.19, green: 0.22, blue: 0.34)
        ]

        static let splashBackground = [
            Color(red: 0.06, green: 0.07, blue: 0.16),
            Color(red: 0.13, green: 0.15, blue: 0.36),
            Color(red: 0.42, green: 0.15, blue: 0.72)
        ]

        static let pulseOrb = [
            Color(red: 0.07, green: 0.80, blue: 0.92),
            Color(red: 0.96, green: 0.27, blue: 0.70),
            Color(red: 1.00, green: 0.73, blue: 0.22)
        ]

        static let widgetFallback = [
            Color.indigo,
            Color.cyan,
            Color.pink
        ]

        static let paperConfetti = [
            Color(red: 0.93, green: 0.05, blue: 0.12),
            Color(red: 0.06, green: 0.30, blue: 0.90),
            Color(red: 0.04, green: 0.62, blue: 0.26),
            Color(red: 1.00, green: 0.79, blue: 0.05),
            Color(red: 1.00, green: 0.36, blue: 0.02),
            Color(red: 0.00, green: 0.72, blue: 0.70),
            Color(red: 0.91, green: 0.10, blue: 0.38)
        ]

        static let focusVibe = [Color(red: 0.18, green: 0.27, blue: 0.86), Color(red: 0.10, green: 0.79, blue: 0.88)]
        static let powerVibe = [Color(red: 0.94, green: 0.22, blue: 0.32), Color(red: 1.00, green: 0.67, blue: 0.24)]
        static let chillVibe = [Color(red: 0.20, green: 0.63, blue: 0.77), Color(red: 0.63, green: 0.86, blue: 0.65)]
        static let joyVibe = [Color(red: 1.00, green: 0.72, blue: 0.18), Color(red: 0.99, green: 0.25, blue: 0.57)]
        static let flowVibe = [Color(red: 0.07, green: 0.56, blue: 0.88), Color(red: 0.29, green: 0.89, blue: 0.77)]
        static let sparkVibe = [Color(red: 0.48, green: 0.24, blue: 0.95), Color(red: 0.97, green: 0.36, blue: 0.77)]
    }

    enum Opacity {
        static let secondaryText = 0.78
        static let tertiaryText = 0.66
        static let subduedText = 0.72
        static let panelBorder = 0.24
        static let capsuleFill = 0.28
        static let capsuleBorder = 0.28
        static let progressTrack = 0.24
        static let progressFill = 0.92
        static let cardSelectedFill = 0.26
        static let cardDefaultFill = 0.13
        static let cardSelectedBorder = 0.82
        static let cardDefaultBorder = 0.18
        static let emojiSelectedFill = 0.28
        static let emojiDefaultFill = 0.15
        static let scrim = 0.42
    }

    enum Radius {
        static let card: CGFloat = 22
        static let panel: CGFloat = 24
        static let modal: CGFloat = 32
        static let confetti: CGFloat = 1.5
    }

    enum MaterialStyle {
        static let panel: Material = .ultraThinMaterial
    }
}
