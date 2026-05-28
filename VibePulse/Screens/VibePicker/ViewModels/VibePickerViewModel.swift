//
//  VibePickerViewModel.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation
import SwiftUI
import WidgetKit

@MainActor
final class VibePickerViewModel: ObservableObject {
    private struct Metrics {
        static let pickIncrement = 1
        static let picksPerMilestone = 7
    }

    @Published private(set) var snapshot: VibeSnapshot
    @Published var showMilestoneBurst = false

    var appTitleText: String {
        LocalizedText.value("vibe_picker.title", defaultValue: "VibePulse", comment: "Main app title")
    }

    var appSubtitleText: String {
        LocalizedText.value("vibe_picker.subtitle", defaultValue: "Pick the energy you want to carry today.", comment: "Main app subtitle")
    }

    var options: [VibeOptionViewModel] {
        Vibe.allCases.map(VibeOptionViewModel.init)
    }

    var selectedVibeText: String {
        guard let selectedVibe = snapshot.selectedVibe else {
            return emptyVibeText
        }

        let format = LocalizedText.value(
            "vibe_picker.selected_vibe",
            defaultValue: "Your vibe today: %@ %@!",
            comment: "Selected vibe status. First placeholder is emoji, second is localized vibe name."
        )
        return String(format: format, selectedVibe.emoji, selectedVibe.localizedTitle)
    }

    var emptyVibeText: String {
        LocalizedText.value("vibe_picker.empty_vibe", defaultValue: "No vibe yet - pick one!", comment: "Shown before a vibe is selected")
    }

    var weeklyCountText: String {
        let format = LocalizedText.pluralFormat(
            "vibe_picker.weekly_count",
            count: snapshot.weeklyPickCount,
            singularDefaultValue: "You've picked %d vibe this week.",
            pluralDefaultValue: "You've picked %d vibes this week.",
            comment: "Weekly vibe pick count"
        )
        return String(format: format, snapshot.weeklyPickCount)
    }

    var nextBurstText: String {
        if isMilestonePick {
            let format = LocalizedText.value(
                "vibe_picker.milestone_footer",
                defaultValue: "Boom! %d-pick burst unlocked - your widget is celebrating.",
                comment: "Shown in the app footer when the user hits a milestone pick."
            )
            return String(format: format, Metrics.picksPerMilestone)
        }

        let format = LocalizedText.pluralFormat(
            "vibe_picker.next_burst_count",
            count: picksUntilNextBurst,
            singularDefaultValue: "%d pick until the next %d-pick burst",
            pluralDefaultValue: "%d picks until the next %d-pick burst",
            comment: "Count until the next milestone animation. First placeholder is remaining picks, second is the milestone size."
        )
        return String(format: format, picksUntilNextBurst, Metrics.picksPerMilestone)
    }

    var milestoneProgressValue: Double {
        guard snapshot.totalPickCount > .zero else { return .zero }
        let currentProgress = snapshot.totalPickCount % Metrics.picksPerMilestone
        return Double(currentProgress == .zero ? Metrics.picksPerMilestone : currentProgress)
    }

    var milestoneProgressTotal: Double {
        Double(Metrics.picksPerMilestone)
    }

    init() {
        snapshot = SharedVibeData.load()
    }

    func pick(_ vibe: Vibe) {
        var next = SharedVibeData.normalized(snapshot)
        next.selectedVibeID = vibe.rawValue
        next.selectedAt = Date()
        next.totalPickCount += Metrics.pickIncrement
        next.pickDates.append(Date())
        next = SharedVibeData.normalized(next)

        if next.totalPickCount % Metrics.picksPerMilestone == 0 {
            next.lastMilestonePick = next.totalPickCount
            showMilestoneBurst = true
        }

        snapshot = next
        SharedVibeData.save(next)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func refresh() {
        snapshot = SharedVibeData.load()
    }

    private var picksUntilNextBurst: Int {
        let currentProgress = snapshot.totalPickCount % Metrics.picksPerMilestone
        return Metrics.picksPerMilestone - (currentProgress == 0 ? Metrics.picksPerMilestone : currentProgress)
    }

    private var isMilestonePick: Bool {
        snapshot.totalPickCount > .zero && snapshot.totalPickCount % Metrics.picksPerMilestone == .zero
    }
}

struct VibeOptionViewModel: Identifiable {
    let vibe: Vibe

    var id: String { vibe.id }
    var emoji: String { vibe.emoji }
    var titleText: String { vibe.localizedTitle }
    var messageText: String { vibe.localizedMessage }
    var colors: [Color] { vibe.colors }

    init(vibe: Vibe) {
        self.vibe = vibe
    }
}

struct MilestoneBurstViewModel {
    static let standard = MilestoneBurstViewModel()

    var streakNumberText: String {
        LocalizedText.value("milestone.streak_number", defaultValue: "7", comment: "Milestone streak number")
    }

    var titleText: String {
        LocalizedText.value("milestone.title", defaultValue: "Vibe streak unlocked", comment: "Milestone animation title")
    }

    var subtitleText: String {
        LocalizedText.value("milestone.subtitle", defaultValue: "Your widget gets a celebration skin.", comment: "Milestone animation subtitle")
    }

    var confirmationButtonText: String {
        LocalizedText.value("milestone.confirmation_button", defaultValue: "Cool, thanks!", comment: "Button that closes the milestone celebration")
    }
}
