//
//  VibePulseApp.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import SwiftUI

@main
struct VibePulseApp: App {
    @StateObject private var viewModel = VibePickerViewModel()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(viewModel)
                .onOpenURL { _ in
                    viewModel.refresh()
                }
        }
    }
}
