//
//  VibePulseWidgetEntryView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI
import WidgetKit

struct VibePulseWidgetEntryView: View {
    private struct Metrics {
        static let defaultEmoji = "✨"
        static let bottomShadeOpacity = 0.26
        static let topGlowOpacity = 0.42
        static let accentGlowOpacity = 0.62
        static let centerGlowOpacity = 0.22
    }

    @Environment(\.widgetFamily) private var family
    let entry: VibeWidgetEntry

    private var viewModel: VibeWidgetViewModel {
        VibeWidgetViewModel(entry: entry)
    }

    private var vibe: Vibe? {
        viewModel.selectedVibe
    }

    var body: some View {
        GeometryReader { proxy in
            let compact = isCompact(size: proxy.size)

            ZStack {
                widgetBackground(compact: compact)
                VibeWidgetCelebrationView(entry: entry)
                content(compact: compact)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
        .widgetURL(viewModel.deepLinkURL)
        .containerBackground(for: .widget) {
            widgetBackground(compact: family == .systemSmall)
        }
    }

    private func content(compact: Bool) -> some View {
        VStack(alignment: .leading) {
            topRow(compact: compact)
            Spacer(minLength: .zero)
            bottomText(compact: compact)
        }
        .foregroundStyle(VibePulseDesign.Palette.primaryText)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func topRow(compact: Bool) -> some View {
        HStack(alignment: .top) {
            Text(vibe?.emoji ?? Metrics.defaultEmoji)
                .font(compact ? .largeTitle : .system(size: 50))
                .lineLimit(1)

            Spacer(minLength: .zero)

            countBadge
                .font(compact ? .caption.weight(.black) : .headline.weight(.black))
        }
    }

    private func bottomText(compact: Bool) -> some View {
        VStack(alignment: .leading) {
            Text(compact ? viewModel.compactTitleText : viewModel.titleText)
                .font(compact ? .title3.weight(.heavy) : .title3.weight(.heavy))
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Text(compact ? viewModel.compactWeeklyCountText : viewModel.weeklyCountText)
                .font(compact ? .caption2.weight(.semibold) : .caption.weight(.semibold))
                .foregroundStyle(VibePulseDesign.Palette.primaryText.opacity(VibePulseDesign.Opacity.secondaryText))
                .lineLimit(compact ? 1 : 2)
                .minimumScaleFactor(0.72)

            milestoneBadgeIfNeeded(compact: compact)
        }
    }

    private var countBadge: some View {
        Text(viewModel.countBadgeText)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.capsuleFill), in: Capsule())
            .overlay(Capsule().stroke(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.capsuleBorder)))
    }

    @ViewBuilder
    private func milestoneBadgeIfNeeded(compact: Bool) -> some View {
        if entry.snapshot.isMilestone {
            Text(viewModel.milestoneBadgeText)
                .font(compact ? .caption2.weight(.black) : .caption.weight(.black))
                .textCase(.uppercase)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.capsuleFill), in: Capsule())
                .overlay(Capsule().stroke(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.capsuleBorder)))
        }
    }

    private func isCompact(size: CGSize) -> Bool {
        family == .systemSmall || size.width <= size.height * 1.35
    }

    private func widgetBackground(compact: Bool) -> some View {
        let colors = vibe?.colors ?? VibePulseDesign.Palette.widgetFallback
        let firstColor = colors.first ?? VibePulseDesign.Palette.widgetFallback[0]
        let secondColor = colors.dropFirst().first ?? VibePulseDesign.Palette.widgetFallback[1]
        let accentColor = colors.last ?? VibePulseDesign.Palette.widgetFallback[2]

        return GeometryReader { proxy in
            let glowRadius = max(proxy.size.width, proxy.size.height)

            ZStack {
                LinearGradient(
                    colors: [firstColor, secondColor, accentColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                LinearGradient(
                    colors: [
                        VibePulseDesign.Palette.clearShade,
                        VibePulseDesign.Palette.shade.opacity(Metrics.bottomShadeOpacity)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                RadialGradient(
                    colors: [
                        VibePulseDesign.Palette.highlight.opacity(Metrics.topGlowOpacity),
                        VibePulseDesign.Palette.highlight.opacity(.zero)
                    ],
                    center: .topLeading,
                    startRadius: .zero,
                    endRadius: glowRadius
                )
                .blendMode(.screen)

                RadialGradient(
                    colors: [accentColor.opacity(Metrics.accentGlowOpacity), accentColor.opacity(.zero)],
                    center: .bottomTrailing,
                    startRadius: .zero,
                    endRadius: glowRadius
                )
                .blendMode(.screen)

                if !compact {
                    RadialGradient(
                        colors: [secondColor.opacity(Metrics.centerGlowOpacity), secondColor.opacity(.zero)],
                        center: .center,
                        startRadius: .zero,
                        endRadius: glowRadius
                    )
                    .blendMode(.screen)
                }
            }
        }
    }
}
