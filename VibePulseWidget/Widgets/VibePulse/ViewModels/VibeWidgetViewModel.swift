//
//  VibeWidgetViewModel.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation

struct VibeWidgetViewModel {
    private struct Metrics {
        static let displayNameKey = "widget.display_name"
        static let descriptionKey = "widget.description"
        static let titleKey = "widget.selected_vibe"
        static let compactTitleKey = "widget.compact_selected_vibe"
        static let emptyTitleKey = "widget.empty_vibe"
        static let compactEmptyTitleKey = "widget.compact_empty_vibe"
        static let weeklyCountKey = "widget.weekly_count"
        static let compactWeeklyCountKey = "widget.compact_weekly_count"
        static let milestoneBadgeKey = "widget.milestone_badge"
        static let displayNameDefault = "VibePulse"
        static let descriptionDefault = "Shows your latest vibe and weekly pick count."
        static let titleDefault = "Your vibe: %@"
        static let compactTitleDefault = "%@"
        static let emptyTitleDefault = "No vibe yet - pick one!"
        static let compactEmptyTitleDefault = "Pick one!"
        static let milestoneBadgeDefault = "%d-pick burst"
        static let picksPerMilestone = 7
        static let deepLinkURLString = "vibepulse://selected-vibe"
    }

    let entry: VibeWidgetEntry

    static var displayNameText: String {
        LocalizedText.value(Metrics.displayNameKey, defaultValue: Metrics.displayNameDefault, comment: "Widget display name")
    }

    static var descriptionText: String {
        LocalizedText.value(Metrics.descriptionKey, defaultValue: Metrics.descriptionDefault, comment: "Widget description")
    }

    var selectedVibe: Vibe? {
        entry.snapshot.selectedVibe
    }

    var titleText: String {
        guard let selectedVibe else {
            return LocalizedText.value(Metrics.emptyTitleKey, defaultValue: Metrics.emptyTitleDefault, comment: "Widget empty state title")
        }

        let format = LocalizedText.value(
            Metrics.titleKey,
            defaultValue: Metrics.titleDefault,
            comment: "Widget selected vibe title. Placeholder is localized vibe name."
        )
        return String(format: format, selectedVibe.localizedTitle)
    }

    var compactTitleText: String {
        guard let selectedVibe else {
            return LocalizedText.value(Metrics.compactEmptyTitleKey, defaultValue: Metrics.compactEmptyTitleDefault, comment: "Compact widget empty title")
        }

        let format = LocalizedText.value(
            Metrics.compactTitleKey,
            defaultValue: Metrics.compactTitleDefault,
            comment: "Compact widget selected vibe title. Placeholder is localized vibe name."
        )
        return String(format: format, selectedVibe.localizedTitle)
    }

    var weeklyCountText: String {
        let format = LocalizedText.pluralFormat(
            Metrics.weeklyCountKey,
            count: entry.snapshot.weeklyPickCount,
            singularDefaultValue: "You've picked %d vibe this week.",
            pluralDefaultValue: "You've picked %d vibes this week.",
            comment: "Widget weekly pick count"
        )
        return String(format: format, entry.snapshot.weeklyPickCount)
    }

    var compactWeeklyCountText: String {
        let format = LocalizedText.value(
            Metrics.compactWeeklyCountKey,
            defaultValue: "%d this week",
            comment: "Compact widget weekly count"
        )
        return String(format: format, entry.snapshot.weeklyPickCount)
    }

    var milestoneBadgeText: String {
        let format = LocalizedText.value(
            Metrics.milestoneBadgeKey,
            defaultValue: Metrics.milestoneBadgeDefault,
            comment: "Widget milestone badge. Placeholder is the milestone size."
        )
        return String(format: format, Metrics.picksPerMilestone)
    }

    var countBadgeText: String {
        "\(entry.snapshot.weeklyPickCount)"
    }

    var deepLinkURL: URL? {
        URL(string: Metrics.deepLinkURLString)
    }
}
