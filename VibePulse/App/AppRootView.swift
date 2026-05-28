//
//  AppRootView.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

struct AppRootView: View {
    private struct Metrics {
        static let splashTransitionResponse = 0.5
        static let splashTransitionDamping = 0.86
    }

    @EnvironmentObject private var viewModel: VibePickerViewModel
    @State private var isShowingSplash = true

    var body: some View {
        ZStack {
            VibePickerView()
                .environmentObject(viewModel)

            if isShowingSplash {
                SplashView(viewModel: SplashViewModel()) {
                    withAnimation(.spring(response: Metrics.splashTransitionResponse, dampingFraction: Metrics.splashTransitionDamping)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)
            }
        }
    }
}
