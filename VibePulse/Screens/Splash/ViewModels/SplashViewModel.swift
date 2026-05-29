//
//  SplashViewModel.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation
import SwiftUI

struct SplashViewModel {
    private struct Metrics {
        static let appNameKey = "splash.app_name"
        static let taglineKey = "splash.tagline"
        static let appNameDefault = "VibePulse"
        static let taglineDefault = "Tune into today"
        static let baseParticleRadius: CGFloat = 96
        static let particleRadiusStep: CGFloat = 10
        static let particleBaseSize: CGFloat = 24
        static let particleSizeStep: CGFloat = 2
        static let fullCircleDegrees = 360.0
    }

    var appNameText: String {
        LocalizedText.value(Metrics.appNameKey, defaultValue: Metrics.appNameDefault, comment: "Splash screen app name")
    }

    var taglineText: String {
        LocalizedText.value(Metrics.taglineKey, defaultValue: Metrics.taglineDefault, comment: "Splash screen tagline")
    }

    var particles: [SplashParticle] {
        Vibe.allCases.enumerated().map { index, vibe in
            SplashParticle(
                id: index,
                symbol: vibe.emoji,
                color: vibe.colors.last ?? VibePulseDesign.Palette.highlight,
                angle: .degrees(Double(index) / Double(Vibe.allCases.count) * Metrics.fullCircleDegrees),
                radius: Metrics.baseParticleRadius + CGFloat(index % 2) * Metrics.particleRadiusStep,
                size: Metrics.particleBaseSize + CGFloat(index % 3) * Metrics.particleSizeStep
            )
        }
    }
}
