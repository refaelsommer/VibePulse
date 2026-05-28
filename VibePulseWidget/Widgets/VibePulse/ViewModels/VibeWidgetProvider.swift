//
//  VibeWidgetProvider.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation
import WidgetKit

struct VibeWidgetProvider: TimelineProvider {
    fileprivate struct Metrics {
        static let restingPhase = -1
        static let firstCelebrationPhase = 0
        static let celebrationFrameCount = 6
        static let celebrationWindowMinutes = 8
        static let refreshIntervalHours = 1
    }

    func placeholder(in context: Context) -> VibeWidgetEntry {
        VibeWidgetEntry(date: Date(), snapshot: .empty, phase: Metrics.restingPhase)
    }

    func getSnapshot(in context: Context, completion: @escaping (VibeWidgetEntry) -> Void) {
        completion(VibeWidgetEntry(date: Date(), snapshot: SharedVibeData.load(), phase: Metrics.firstCelebrationPhase))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VibeWidgetEntry>) -> Void) {
        let snapshot = SharedVibeData.load()
        let now = Date()

        let entries = snapshot.shouldShowTimelineCelebration(now: now)
            ? celebrationEntries(for: snapshot, now: now)
            : [VibeWidgetEntry(date: now, snapshot: snapshot, phase: Metrics.restingPhase)]

        let refreshDate = Calendar.current.date(byAdding: .hour, value: Metrics.refreshIntervalHours, to: now) ?? now
        completion(Timeline(entries: entries, policy: .after(refreshDate)))
    }

    private func celebrationEntries(for snapshot: VibeSnapshot, now: Date) -> [VibeWidgetEntry] {
        let celebrationFrames = (0..<Metrics.celebrationFrameCount).map { phase in
            VibeWidgetEntry(
                date: Calendar.current.date(byAdding: .minute, value: phase, to: now) ?? now,
                snapshot: snapshot,
                phase: phase
            )
        }

        let restingDate = Calendar.current.date(
            byAdding: .minute,
            value: Metrics.celebrationFrameCount,
            to: now
        ) ?? now

        return celebrationFrames + [
            VibeWidgetEntry(date: restingDate, snapshot: snapshot, phase: Metrics.restingPhase)
        ]
    }
}

private extension VibeSnapshot {
    func shouldShowTimelineCelebration(now: Date) -> Bool {
        guard isMilestone, let selectedAt else { return false }
        let celebrationWindow = TimeInterval(VibeWidgetProvider.Metrics.celebrationWindowMinutes * 60)
        return now.timeIntervalSince(selectedAt) <= celebrationWindow
    }
}
