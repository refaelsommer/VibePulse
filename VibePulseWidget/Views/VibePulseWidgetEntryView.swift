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
        .foregroundStyle(.white)
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
                .foregroundStyle(.white.secondary)
                .lineLimit(compact ? 1 : 2)
                .minimumScaleFactor(0.72)

            milestoneBadgeIfNeeded(compact: compact)
        }
    }

    private var countBadge: some View {
        Text(viewModel.countBadgeText)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.white.opacity(0.28), in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.28)))
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
                .background(.white.opacity(0.28), in: Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.28)))
        }
    }

    private func isCompact(size: CGSize) -> Bool {
        family == .systemSmall || size.width <= size.height * 1.35
    }

    private func widgetBackground(compact: Bool) -> some View {
        let colors = vibe?.colors ?? [.indigo, .cyan, .pink]
        let firstColor = colors.first ?? .indigo
        let secondColor = colors.dropFirst().first ?? .cyan
        let accentColor = colors.last ?? .pink

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
                        Color.black.opacity(.zero),
                        Color.black.opacity(0.26)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                RadialGradient(
                    colors: [Color.white.opacity(0.42), Color.white.opacity(.zero)],
                    center: .topLeading,
                    startRadius: .zero,
                    endRadius: glowRadius
                )
                .blendMode(.screen)

                RadialGradient(
                    colors: [accentColor.opacity(0.62), accentColor.opacity(.zero)],
                    center: .bottomTrailing,
                    startRadius: .zero,
                    endRadius: glowRadius
                )
                .blendMode(.screen)

                if !compact {
                    RadialGradient(
                        colors: [secondColor.opacity(0.22), secondColor.opacity(.zero)],
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
