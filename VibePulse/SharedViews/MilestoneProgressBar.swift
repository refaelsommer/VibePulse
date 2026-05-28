//
//  MilestoneProgressBar.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct MilestoneProgressBar: View {
    private struct Metrics {
        static let trackOpacity = 0.24
        static let fillOpacity = 0.92
        static let height: CGFloat = 8
    }

    let value: Double
    let total: Double

    var body: some View {
        GeometryReader { proxy in
            Capsule()
                .fill(.white.opacity(Metrics.trackOpacity))
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(Metrics.fillOpacity))
                        .frame(width: proxy.size.width * progressRatio)
                }
        }
        .frame(height: Metrics.height)
    }

    private var progressRatio: Double {
        guard total > .zero else { return .zero }
        return min(max(value / total, .zero), 1)
    }
}
