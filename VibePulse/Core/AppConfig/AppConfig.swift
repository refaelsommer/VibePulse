//
//  AppConfig.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation
import WidgetKit

enum AppConfig {
    enum Identifiers {
        static let appGroupID = "group.com.refaelsommer.vibepulse"
        static let widgetKind = "VibePulseWidget"
        static let selectedVibeDeepLinkURL = URL(string: "vibepulse://selected-vibe")
    }

    enum Milestones {
        static let picksPerBurst = 7
    }

    enum Widget {
        static let supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium]
        static let restingPhase = -1
        static let firstCelebrationPhase = 0
        static let celebrationFrameCount = 36
        static let celebrationFrameIntervalSeconds = 1
        static let celebrationWindowMinutes = 8
        static let refreshIntervalHours = 1
    }
}
