//
//  VibePulseWidgetEntryView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI
import WidgetKit

struct VibePulseWidgetEntryView: View {
    struct Metrics {
        static let badgeBackgroundOpacity = 0.28
        static let badgeBorderOpacity = 0.28
        static let badgeBorderWidth: CGFloat = 1
        static let mediumStackSpacing: CGFloat = 10
        static let smallStackSpacing: CGFloat = 7
        static let mediumEmojiFontSize: CGFloat = 50
        static let smallEmojiFontSize: CGFloat = 38
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeVerticalPadding: CGFloat = 6
        static let bottomSpacerMinLength: CGFloat = 2
        static let titleScaleFactor = 0.7
        static let weeklyCountOpacity = 0.88
        static let weeklyCountLineLimit = 2
        static let milestoneBadgeHorizontalPadding: CGFloat = 11
        static let milestoneBadgeVerticalPadding: CGFloat = 6
        static let milestoneBadgeBackgroundOpacity = 0.3
        static let milestoneBadgeBorderOpacity = 0.24
        static let contentPadding: CGFloat = 18
        static let contentBottomPadding: CGFloat = 24
        static let backgroundShadeOpacity = 0.26
        static let topGlowOpacity = 0.42
        static let bottomGlowOpacity = 0.62
        static let centerGlowOpacity = 0.22
        static let waveOpacity = 0.18
        static let waveWidth: CGFloat = 260
        static let waveHeight: CGFloat = 92
        static let waveBlur: CGFloat = 16
        static let waveRotationDegrees = -17.0
        static let waveOffset = CGSize(width: 70, height: -24)
        static let smallTopGlowRadius: CGFloat = 170
        static let mediumTopGlowRadius: CGFloat = 260
        static let smallBottomGlowRadius: CGFloat = 190
        static let mediumBottomGlowRadius: CGFloat = 290
        static let smallCenterGlowRadius: CGFloat = 150
        static let mediumCenterGlowRadius: CGFloat = 220
        static let fallbackAccentColor = Color(red: 1.0, green: 0.28, blue: 0.68)
        static let shadeColor = Color(red: 0.02, green: 0.03, blue: 0.09)
        static let defaultEmoji = "✨"
        static let defaultBackgroundColors = [
            Color(red: 0.10, green: 0.12, blue: 0.30),
            Color(red: 0.06, green: 0.70, blue: 0.86),
            Color(red: 0.93, green: 0.22, blue: 0.62)
        ]
    }
    
    @Environment(\.widgetFamily) private var family
    let entry: VibeWidgetEntry

    private var vibe: Vibe? {
        viewModel.selectedVibe
    }

    private var viewModel: VibeWidgetViewModel {
        VibeWidgetViewModel(entry: entry)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            widgetBackground
            VibeWidgetCelebrationView(entry: entry)

            VStack(alignment: .leading, spacing: family == .systemSmall ? Metrics.smallStackSpacing : Metrics.mediumStackSpacing) {
                HStack {
                    Text(vibe?.emoji ?? Metrics.defaultEmoji)
                        .font(.system(size: family == .systemSmall ? Metrics.smallEmojiFontSize : Metrics.mediumEmojiFontSize))
                    Spacer()
                    Text(viewModel.countBadgeText)
                        .font(.headline.weight(.black))
                        .padding(.horizontal, Metrics.badgeHorizontalPadding)
                        .padding(.vertical, Metrics.badgeVerticalPadding)
                        .background(.white.opacity(Metrics.badgeBackgroundOpacity), in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(Metrics.badgeBorderOpacity), lineWidth: Metrics.badgeBorderWidth)
                        )
                }

                Spacer(minLength: Metrics.bottomSpacerMinLength)

                Text(viewModel.titleText)
                    .font(family == .systemSmall ? .headline.weight(.heavy) : .title3.weight(.heavy))
                    .minimumScaleFactor(Metrics.titleScaleFactor)

                Text(viewModel.weeklyCountText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(Metrics.weeklyCountOpacity))
                    .lineLimit(Metrics.weeklyCountLineLimit)

                if entry.snapshot.isMilestone {
                    Text(viewModel.milestoneBadgeText)
                        .font(.caption2.weight(.black))
                        .textCase(.uppercase)
                        .padding(.horizontal, Metrics.milestoneBadgeHorizontalPadding)
                        .padding(.vertical, Metrics.milestoneBadgeVerticalPadding)
                        .background(.white.opacity(Metrics.milestoneBadgeBackgroundOpacity), in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(Metrics.milestoneBadgeBorderOpacity), lineWidth: Metrics.badgeBorderWidth)
                        )
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, Metrics.contentPadding)
            .padding(.top, Metrics.contentPadding)
            .padding(.bottom, Metrics.contentBottomPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .widgetURL(viewModel.deepLinkURL)
        .containerBackground(for: .widget) {
            widgetBackground
        }
    }

    private var widgetBackground: some View {
        let colors = vibe?.colors ?? Metrics.defaultBackgroundColors
        let firstColor = colors.first ?? Metrics.defaultBackgroundColors[0]
        let secondColor = colors.dropFirst().first ?? Metrics.defaultBackgroundColors[1]
        let accentColor = colors.last ?? Metrics.fallbackAccentColor

        return ZStack {
            LinearGradient(
                colors: [
                    firstColor,
                    secondColor,
                    accentColor
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    Metrics.shadeColor.opacity(.zero),
                    Metrics.shadeColor.opacity(Metrics.backgroundShadeOpacity)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [
                    Color.white.opacity(Metrics.topGlowOpacity),
                    Color.white.opacity(.zero)
                ],
                center: .topLeading,
                startRadius: .zero,
                endRadius: family == .systemSmall ? Metrics.smallTopGlowRadius : Metrics.mediumTopGlowRadius
            )
            .blendMode(.screen)

            RadialGradient(
                colors: [
                    accentColor.opacity(Metrics.bottomGlowOpacity),
                    accentColor.opacity(.zero)
                ],
                center: .bottomTrailing,
                startRadius: .zero,
                endRadius: family == .systemSmall ? Metrics.smallBottomGlowRadius : Metrics.mediumBottomGlowRadius
            )
            .blendMode(.screen)

            RadialGradient(
                colors: [
                    secondColor.opacity(Metrics.centerGlowOpacity),
                    secondColor.opacity(.zero)
                ],
                center: .center,
                startRadius: .zero,
                endRadius: family == .systemSmall ? Metrics.smallCenterGlowRadius : Metrics.mediumCenterGlowRadius
            )
            .blendMode(.screen)

            Capsule()
                .fill(.white.opacity(Metrics.waveOpacity))
                .frame(width: Metrics.waveWidth, height: Metrics.waveHeight)
                .blur(radius: Metrics.waveBlur)
                .rotationEffect(.degrees(Metrics.waveRotationDegrees))
                .offset(Metrics.waveOffset)
        }
    }
}
