//
//  VibeWidgetProvider.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation
import WidgetKit

struct VibeWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> VibeWidgetEntry {
        VibeWidgetEntry(date: Date(), snapshot: .empty, phase: AppConfig.Widget.restingPhase)
    }

    func getSnapshot(in context: Context, completion: @escaping (VibeWidgetEntry) -> Void) {
        completion(VibeWidgetEntry(date: Date(), snapshot: SharedVibeData.load(), phase: AppConfig.Widget.firstCelebrationPhase))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VibeWidgetEntry>) -> Void) {
        let snapshot = SharedVibeData.load()
        let now = Date()

        let entries = snapshot.shouldShowTimelineCelebration(now: now)
            ? celebrationEntries(for: snapshot, now: now)
            : [VibeWidgetEntry(date: now, snapshot: snapshot, phase: AppConfig.Widget.restingPhase)]

        let refreshDate = Calendar.current.date(byAdding: .hour, value: AppConfig.Widget.refreshIntervalHours, to: now) ?? now
        completion(Timeline(entries: entries, policy: .after(refreshDate)))
    }

    private func celebrationEntries(for snapshot: VibeSnapshot, now: Date) -> [VibeWidgetEntry] {
        let celebrationFrames = (0..<AppConfig.Widget.celebrationFrameCount).map { phase in
            VibeWidgetEntry(
                date: Calendar.current.date(byAdding: .minute, value: phase, to: now) ?? now,
                snapshot: snapshot,
                phase: phase
            )
        }

        let restingDate = Calendar.current.date(
            byAdding: .minute,
            value: AppConfig.Widget.celebrationFrameCount,
            to: now
        ) ?? now

        return celebrationFrames + [
            VibeWidgetEntry(date: restingDate, snapshot: snapshot, phase: AppConfig.Widget.restingPhase)
        ]
    }
}

private extension VibeSnapshot {
    func shouldShowTimelineCelebration(now: Date) -> Bool {
        guard isMilestone, let selectedAt else { return false }
        let celebrationWindow = TimeInterval(AppConfig.Widget.celebrationWindowMinutes * 60)
        return now.timeIntervalSince(selectedAt) <= celebrationWindow
    }
}
