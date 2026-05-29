//
//  Vibe.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

enum Vibe: String, CaseIterable, Codable, Identifiable {
    struct Metrics {
        static let focusTitleKey = "vibe.focus.title"
        static let powerTitleKey = "vibe.power.title"
        static let chillTitleKey = "vibe.chill.title"
        static let joyTitleKey = "vibe.joy.title"
        static let flowTitleKey = "vibe.flow.title"
        static let sparkTitleKey = "vibe.spark.title"
        static let focusMessageKey = "vibe.focus.message"
        static let powerMessageKey = "vibe.power.message"
        static let chillMessageKey = "vibe.chill.message"
        static let joyMessageKey = "vibe.joy.message"
        static let flowMessageKey = "vibe.flow.message"
        static let sparkMessageKey = "vibe.spark.message"
        static let focusTitleDefault = "Focus"
        static let powerTitleDefault = "Power"
        static let chillTitleDefault = "Chill"
        static let joyTitleDefault = "Joy"
        static let flowTitleDefault = "Flow"
        static let sparkTitleDefault = "Spark"
        static let focusEmoji = "🧠"
        static let powerEmoji = "💪"
        static let chillEmoji = "😴"
        static let joyEmoji = "😂"
        static let flowEmoji = "🌊"
        static let sparkEmoji = "🚀"
        static let focusMessageDefault = "Deep work mode"
        static let powerMessageDefault = "Big energy"
        static let chillMessageDefault = "Soft landing"
        static let joyMessageDefault = "Light it up"
        static let flowMessageDefault = "Smooth momentum"
        static let sparkMessageDefault = "Fresh ignition"
    }

    case focus
    case power
    case chill
    case joy
    case flow
    case spark

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .focus: LocalizedText.value(Metrics.focusTitleKey, defaultValue: Metrics.focusTitleDefault, comment: "Focus vibe name")
        case .power: LocalizedText.value(Metrics.powerTitleKey, defaultValue: Metrics.powerTitleDefault, comment: "Power vibe name")
        case .chill: LocalizedText.value(Metrics.chillTitleKey, defaultValue: Metrics.chillTitleDefault, comment: "Chill vibe name")
        case .joy: LocalizedText.value(Metrics.joyTitleKey, defaultValue: Metrics.joyTitleDefault, comment: "Joy vibe name")
        case .flow: LocalizedText.value(Metrics.flowTitleKey, defaultValue: Metrics.flowTitleDefault, comment: "Flow vibe name")
        case .spark: LocalizedText.value(Metrics.sparkTitleKey, defaultValue: Metrics.sparkTitleDefault, comment: "Spark vibe name")
        }
    }

    var emoji: String {
        switch self {
        case .focus: Metrics.focusEmoji
        case .power: Metrics.powerEmoji
        case .chill: Metrics.chillEmoji
        case .joy: Metrics.joyEmoji
        case .flow: Metrics.flowEmoji
        case .spark: Metrics.sparkEmoji
        }
    }

    var localizedMessage: String {
        switch self {
        case .focus: LocalizedText.value(Metrics.focusMessageKey, defaultValue: Metrics.focusMessageDefault, comment: "Focus vibe subtitle")
        case .power: LocalizedText.value(Metrics.powerMessageKey, defaultValue: Metrics.powerMessageDefault, comment: "Power vibe subtitle")
        case .chill: LocalizedText.value(Metrics.chillMessageKey, defaultValue: Metrics.chillMessageDefault, comment: "Chill vibe subtitle")
        case .joy: LocalizedText.value(Metrics.joyMessageKey, defaultValue: Metrics.joyMessageDefault, comment: "Joy vibe subtitle")
        case .flow: LocalizedText.value(Metrics.flowMessageKey, defaultValue: Metrics.flowMessageDefault, comment: "Flow vibe subtitle")
        case .spark: LocalizedText.value(Metrics.sparkMessageKey, defaultValue: Metrics.sparkMessageDefault, comment: "Spark vibe subtitle")
        }
    }

    var colors: [Color] {
        switch self {
        case .focus: VibePulseDesign.Palette.focusVibe
        case .power: VibePulseDesign.Palette.powerVibe
        case .chill: VibePulseDesign.Palette.chillVibe
        case .joy: VibePulseDesign.Palette.joyVibe
        case .flow: VibePulseDesign.Palette.flowVibe
        case .spark: VibePulseDesign.Palette.sparkVibe
        }
    }
}
