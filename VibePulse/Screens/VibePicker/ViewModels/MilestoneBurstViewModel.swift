//
//  MilestoneBurstViewModel.swift
//  VibePulse
//
//  Created by Refael Sommer on 01/06/2026.
//

import Foundation

struct MilestoneBurstViewModel {
    static let standard = MilestoneBurstViewModel()

    var streakNumberText: String {
        let defaultValue = "\(AppConfig.Milestones.picksPerBurst)"
        return LocalizedText.value("milestone.streak_number", defaultValue: defaultValue, comment: "Milestone streak number")
    }

    var titleText: String {
        LocalizedText.value("milestone.title", defaultValue: "Vibe streak unlocked", comment: "Milestone animation title")
    }

    var subtitleText: String {
        LocalizedText.value("milestone.subtitle", defaultValue: "Your widget gets a celebration skin.", comment: "Milestone animation subtitle")
    }

    var confirmationButtonText: String {
        LocalizedText.value("milestone.confirmation_button", defaultValue: "Cool, thanks!", comment: "Button that closes the milestone celebration")
    }
}
