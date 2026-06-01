//
//  VibeOptionViewModel.swift
//  VibePulse
//
//  Created by Refael Sommer on 01/06/2026.
//

import SwiftUI

struct VibeOptionViewModel: Identifiable {
    let vibe: Vibe

    var id: String { vibe.id }
    var emoji: String { vibe.emoji }
    var titleText: String { vibe.localizedTitle }
    var messageText: String { vibe.localizedMessage }
    var colors: [Color] { vibe.colors }

    init(vibe: Vibe) {
        self.vibe = vibe
    }
}
