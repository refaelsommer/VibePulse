//
//  VibePickerView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibePickerView: View {
    private struct Metrics {
        static let selectedPulseScale = 1.04
        static let selectionPulseResponse = 0.3
        static let selectionPulseDamping = 0.45
        static let progressFillResponse = 0.7
        static let progressFillDamping = 0.82
        static let milestoneDismissResponse = 0.45
        static let milestoneDismissDamping = 0.82
        static let backgroundLoopDuration = 12.0
        static let backgroundTransitionResponse = 0.75
        static let backgroundTransitionDamping = 0.9
        static let glowOpacity = 0.18
        static let glowSize: CGFloat = 280
        static let glowBlur: CGFloat = 32
        static let glowStartOffset = CGSize(width: -120, height: -160)
        static let glowEndOffset = CGSize(width: 110, height: -260)
        static let shadeOpacity = 0.18
        static let shadeSize: CGFloat = 360
        static let shadeBlur: CGFloat = 42
        static let shadeStartOffset = CGSize(width: 120, height: 170)
        static let shadeEndOffset = CGSize(width: -130, height: 260)
    }

    @EnvironmentObject private var viewModel: VibePickerViewModel
    @State private var backgroundSpin = false
    @State private var selectedPulse = false
    @State private var displayedMilestoneProgress = 0.0

    private var selectedVibe: Vibe? {
        viewModel.snapshot.selectedVibe
    }

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            background

            GeometryReader { proxy in
                ScrollView {
                    VStack {
                        header
                        vibeGrid
                        footerArea
                    }
                    .safeAreaPadding(.horizontal)
                    .padding(.vertical)
                    .frame(minHeight: proxy.size.height)
                }
                .scrollIndicators(.hidden)
            }
        }
        .overlay {
            if viewModel.showMilestoneBurst {
                MilestoneBurstView(viewModel: .standard) {
                    withAnimation(.spring(response: Metrics.milestoneDismissResponse, dampingFraction: Metrics.milestoneDismissDamping)) {
                        viewModel.showMilestoneBurst = false
                    }
                }
            }
        }
        .onAppear {
            displayedMilestoneProgress = viewModel.milestoneProgressValue
            withAnimation(.linear(duration: Metrics.backgroundLoopDuration).repeatForever(autoreverses: false)) {
                backgroundSpin = true
            }
        }
        .onChange(of: viewModel.milestoneProgressValue) { _, newValue in
            withAnimation(.spring(response: Metrics.progressFillResponse, dampingFraction: Metrics.progressFillDamping)) {
                displayedMilestoneProgress = newValue
            }
        }
    }

    private var background: some View {
        let colors = selectedVibe?.colors ?? VibePulseDesign.Palette.defaultBackground

        return ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .fill(VibePulseDesign.Palette.highlight.opacity(Metrics.glowOpacity))
                .frame(width: Metrics.glowSize, height: Metrics.glowSize)
                .blur(radius: Metrics.glowBlur)
                .offset(backgroundSpin ? Metrics.glowEndOffset : Metrics.glowStartOffset)
            Circle()
                .fill(VibePulseDesign.Palette.shade.opacity(Metrics.shadeOpacity))
                .frame(width: Metrics.shadeSize, height: Metrics.shadeSize)
                .blur(radius: Metrics.shadeBlur)
                .offset(backgroundSpin ? Metrics.shadeEndOffset : Metrics.shadeStartOffset)
        }
        .ignoresSafeArea()
        .animation(.spring(response: Metrics.backgroundTransitionResponse, dampingFraction: Metrics.backgroundTransitionDamping), value: selectedVibe)
    }

    private var header: some View {
        VStack {
            Text(viewModel.appTitleText)
                .font(.largeTitle.weight(.black))
                .foregroundStyle(VibePulseDesign.Palette.primaryText)

            Text(viewModel.appSubtitleText)
                .font(.headline)
                .foregroundStyle(VibePulseDesign.Palette.primaryText.opacity(VibePulseDesign.Opacity.secondaryText))
                .multilineTextAlignment(.center)
        }
    }

    private var vibeGrid: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(viewModel.options) { option in
                Button {
                    select(option.vibe)
                } label: {
                    VibeCardView(viewModel: option, isSelected: option.vibe == selectedVibe)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var statusPanel: some View {
        VStack {
            Text(viewModel.selectedVibeText)
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)
                .scaleEffect(selectedPulse ? Metrics.selectedPulseScale : 1)
                .animation(.spring(response: Metrics.selectionPulseResponse, dampingFraction: Metrics.selectionPulseDamping), value: selectedPulse)

            Text(viewModel.weeklyCountText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(VibePulseDesign.Palette.primaryText.opacity(VibePulseDesign.Opacity.secondaryText))
                .multilineTextAlignment(.center)

            CapsuleProgressBar(value: displayedMilestoneProgress, total: viewModel.milestoneProgressTotal)

            Text(viewModel.nextBurstText)
                .font(.caption.weight(.medium))
                .foregroundStyle(VibePulseDesign.Palette.primaryText.opacity(VibePulseDesign.Opacity.tertiaryText))
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(VibePulseDesign.Palette.primaryText)
        .padding()
        .frame(maxWidth: .infinity)
        .background(VibePulseDesign.MaterialStyle.panel, in: RoundedRectangle(cornerRadius: VibePulseDesign.Radius.panel, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: VibePulseDesign.Radius.panel, style: .continuous)
                .stroke(VibePulseDesign.Palette.highlight.opacity(VibePulseDesign.Opacity.panelBorder))
        )
    }

    private var footerArea: some View {
        VStack {
            Spacer(minLength: .zero)
            statusPanel
            Spacer(minLength: .zero)
        }
        .frame(maxHeight: .infinity)
    }

    private func select(_ vibe: Vibe) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        viewModel.pick(vibe)
        selectedPulse.toggle()
    }
}
