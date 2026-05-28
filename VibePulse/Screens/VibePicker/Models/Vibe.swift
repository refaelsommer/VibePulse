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
        static let focusColors = [Color(red: 0.18, green: 0.27, blue: 0.86), Color(red: 0.10, green: 0.79, blue: 0.88)]
        static let powerColors = [Color(red: 0.94, green: 0.22, blue: 0.32), Color(red: 1.00, green: 0.67, blue: 0.24)]
        static let chillColors = [Color(red: 0.20, green: 0.63, blue: 0.77), Color(red: 0.63, green: 0.86, blue: 0.65)]
        static let joyColors = [Color(red: 1.00, green: 0.72, blue: 0.18), Color(red: 0.99, green: 0.25, blue: 0.57)]
        static let flowColors = [Color(red: 0.07, green: 0.56, blue: 0.88), Color(red: 0.29, green: 0.89, blue: 0.77)]
        static let sparkColors = [Color(red: 0.48, green: 0.24, blue: 0.95), Color(red: 0.97, green: 0.36, blue: 0.77)]
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
        case .focus: Metrics.focusColors
        case .power: Metrics.powerColors
        case .chill: Metrics.chillColors
        case .joy: Metrics.joyColors
        case .flow: Metrics.flowColors
        case .spark: Metrics.sparkColors
        }
    }
}
