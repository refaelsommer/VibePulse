//
//  VibeSnapshot.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation

struct VibeSnapshot: Codable, Equatable {
    private struct Metrics {
        static let emptyPickCount = 0
    }

    var selectedVibeID: String?
    var selectedAt: Date?
    var weeklyPickCount: Int
    var totalPickCount: Int
    var lastMilestonePick: Int
    var pickDates: [Date]

    static let empty = VibeSnapshot(
        selectedVibeID: nil,
        selectedAt: nil,
        weeklyPickCount: Metrics.emptyPickCount,
        totalPickCount: Metrics.emptyPickCount,
        lastMilestonePick: Metrics.emptyPickCount,
        pickDates: []
    )

    var selectedVibe: Vibe? {
        guard let selectedVibeID else { return nil }
        return Vibe(rawValue: selectedVibeID)
    }

    var isMilestone: Bool {
        totalPickCount > Metrics.emptyPickCount && totalPickCount % AppConfig.Milestones.picksPerBurst == 0
    }
}
