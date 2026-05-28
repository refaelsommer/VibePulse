//
//  VibePickerView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct VibePickerView: View {
    private struct Metrics {
        static let screenHorizontalPadding: CGFloat = 22
        static let screenTopPadding: CGFloat = 62
        static let mainStackSpacing: CGFloat = 28
        static let headerSpacing: CGFloat = 10
        static let titleFontSize: CGFloat = 44
        static let subtitleOpacity = 0.78
        static let gridSpacing: CGFloat = 14
        static let gridColumnCount = 2
        static let statusPanelSpacing: CGFloat = 14
        static let statusPanelPadding: CGFloat = 20
        static let statusPanelCornerRadius: CGFloat = 24
        static let statusPanelBorderWidth: CGFloat = 1
        static let statusPanelBorderOpacity = 0.24
        static let statusTextOpacity = 0.76
        static let progressOpacity = 0.92
        static let progressModulo = 7
        static let captionOpacity = 0.66
        static let emptySpacerMinLength: CGFloat = 0
        static let selectedPulseScale = 1.04
        static let unselectedScale = 1.0
        static let selectionPulseResponse = 0.3
        static let selectionPulseDamping = 0.45
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
        static let defaultBackgroundColors = [Color(red: 0.07, green: 0.08, blue: 0.12), Color(red: 0.19, green: 0.22, blue: 0.34)]
    }

    @EnvironmentObject private var viewModel: VibePickerViewModel
    @State private var backgroundSpin = false
    @State private var selectedPulse = false

    private var selectedVibe: Vibe? {
        viewModel.snapshot.selectedVibe
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: Metrics.mainStackSpacing) {
                header
                vibeGrid
                statusPanel
                Spacer(minLength: Metrics.emptySpacerMinLength)
            }
            .padding(.horizontal, Metrics.screenHorizontalPadding)
            .padding(.top, Metrics.screenTopPadding)
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
            withAnimation(.linear(duration: Metrics.backgroundLoopDuration).repeatForever(autoreverses: false)) {
                backgroundSpin = true
            }
        }
    }

    private var background: some View {
        let colors = selectedVibe?.colors ?? Metrics.defaultBackgroundColors

        return ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .fill(.white.opacity(Metrics.glowOpacity))
                .frame(width: Metrics.glowSize, height: Metrics.glowSize)
                .blur(radius: Metrics.glowBlur)
                .offset(backgroundSpin ? Metrics.glowEndOffset : Metrics.glowStartOffset)
            Circle()
                .fill(.black.opacity(Metrics.shadeOpacity))
                .frame(width: Metrics.shadeSize, height: Metrics.shadeSize)
                .blur(radius: Metrics.shadeBlur)
                .offset(backgroundSpin ? Metrics.shadeEndOffset : Metrics.shadeStartOffset)
        }
        .ignoresSafeArea()
        .animation(.spring(response: Metrics.backgroundTransitionResponse, dampingFraction: Metrics.backgroundTransitionDamping), value: selectedVibe)
    }

    private var header: some View {
        VStack(spacing: Metrics.headerSpacing) {
            Text(viewModel.appTitleText)
                .font(.system(size: Metrics.titleFontSize, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text(viewModel.appSubtitleText)
                .font(.headline)
                .foregroundStyle(.white.opacity(Metrics.subtitleOpacity))
                .multilineTextAlignment(.center)
        }
    }

    private var vibeGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: Metrics.gridColumnCount), spacing: Metrics.gridSpacing) {
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
        VStack(spacing: Metrics.statusPanelSpacing) {
            Text(viewModel.selectedVibeText)
                .font(.title2.weight(.bold))
                .scaleEffect(selectedPulse ? Metrics.selectedPulseScale : Metrics.unselectedScale)
                .animation(.spring(response: Metrics.selectionPulseResponse, dampingFraction: Metrics.selectionPulseDamping), value: selectedPulse)

            Text(viewModel.weeklyCountText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(Metrics.statusTextOpacity))

            ProgressView(value: Double(viewModel.snapshot.totalPickCount % Metrics.progressModulo), total: Double(Metrics.progressModulo))
                .tint(.white)
                .opacity(Metrics.progressOpacity)

            Text(viewModel.nextBurstText)
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(Metrics.captionOpacity))
        }
        .foregroundStyle(.white)
        .padding(Metrics.statusPanelPadding)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Metrics.statusPanelCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.statusPanelCornerRadius, style: .continuous)
                .stroke(.white.opacity(Metrics.statusPanelBorderOpacity), lineWidth: Metrics.statusPanelBorderWidth)
        )
    }

    private func select(_ vibe: Vibe) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        viewModel.pick(vibe)
        selectedPulse.toggle()
    }
}
