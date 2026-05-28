//
//  VibePulseWidget.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI
import WidgetKit

struct VibePulseWidget: Widget {
    private struct Metrics {
        static let widgetKind = "VibePulseWidget"
        static let supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium]
    }

    let kind = Metrics.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VibeWidgetProvider()) { entry in
            VibePulseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(VibeWidgetViewModel.displayNameText)
        .description(VibeWidgetViewModel.descriptionText)
        .supportedFamilies(Metrics.supportedFamilies)
        .contentMarginsDisabled()
    }
}

@main
struct VibePulseWidgetBundle: WidgetBundle {
    var body: some Widget {
        VibePulseWidget()
    }
}
