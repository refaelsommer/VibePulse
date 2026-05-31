//
//  SharedVibeData.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation

enum SharedVibeData {
    private struct Metrics {
        static let snapshotStorageKey = "vibe.snapshot.v1"
    }

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: AppConfig.Identifiers.appGroupID) ?? .standard
    }

    static func load() -> VibeSnapshot {
        guard let data = defaults.data(forKey: Metrics.snapshotStorageKey),
              let snapshot = try? JSONDecoder().decode(VibeSnapshot.self, from: data) else {
            return .empty
        }

        return normalized(snapshot)
    }

    static func save(_ snapshot: VibeSnapshot) {
        guard let data = try? JSONEncoder().encode(normalized(snapshot)) else { return }
        defaults.set(data, forKey: Metrics.snapshotStorageKey)
    }

    static func normalized(_ snapshot: VibeSnapshot, now: Date = Date()) -> VibeSnapshot {
        let calendar = Calendar.current
        let currentWeekDates = snapshot.pickDates.filter {
            calendar.isDate($0, equalTo: now, toGranularity: .weekOfYear)
        }

        return VibeSnapshot(
            selectedVibeID: snapshot.selectedVibeID,
            selectedAt: snapshot.selectedAt,
            weeklyPickCount: currentWeekDates.count,
            totalPickCount: snapshot.totalPickCount,
            lastMilestonePick: snapshot.lastMilestonePick,
            pickDates: currentWeekDates
        )
    }
}
