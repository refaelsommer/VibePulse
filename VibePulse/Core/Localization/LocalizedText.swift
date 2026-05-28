//
//  LocalizedText.swift
//  VibePulse
//
//  Created by Refael Sommer on 28/05/2026.
//

import Foundation

enum LocalizedText {
    static func value(_ key: String, defaultValue: String, comment: String = "") -> String {
        NSLocalizedString(key, tableName: nil, bundle: .main, value: defaultValue, comment: comment)
    }
}
