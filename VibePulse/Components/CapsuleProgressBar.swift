//
//  CapsuleProgressBar.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct CapsuleProgressBar: View {
    private struct Metrics {
        static let height: CGFloat = 8
    }

    private let value: Double
    private let total: Double

    init(value: Double, total: Double) {
        self.value = value
        self.total = total
    }

    var body: some View {
        GeometryReader { proxy in
            Capsule()
                .fill(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.progressTrack))
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.progressFill))
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
