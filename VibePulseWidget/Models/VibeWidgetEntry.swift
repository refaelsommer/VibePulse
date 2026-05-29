//
//  VibeWidgetEntry.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import WidgetKit

struct VibeWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: VibeSnapshot
    let phase: Int

    var isCelebrationFrame: Bool {
        snapshot.isMilestone && phase >= 0
    }
}
