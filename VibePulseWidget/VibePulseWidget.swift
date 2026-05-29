//
//  VibePulseWidget.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI
import WidgetKit

struct VibePulseWidget: Widget {
    let kind = AppConfig.Identifiers.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VibeWidgetProvider()) { entry in
            VibePulseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(VibeWidgetViewModel.displayNameText)
        .description(VibeWidgetViewModel.descriptionText)
        .supportedFamilies(AppConfig.Widget.supportedFamilies)
        .contentMarginsDisabled()
    }
}

@main
struct VibePulseWidgetBundle: WidgetBundle {
    var body: some Widget {
        VibePulseWidget()
    }
}
