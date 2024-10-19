//
//  LanguageManager.swift
//  Meow
//
//  Created by Actor on 2024/10/18.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    @Published var selectedLanguage = "en"

    func setLanguage(_ languageCode: String) {
        if Bundle.main.localizations.contains(languageCode) {
            UserDefaults.standard.set([languageCode], forKey: "MyLanguages")
            selectedLanguage = languageCode
        }
    }

    var supportedLanguages: [String] {
        return ["en", "zh-Hans", "zh-Hant", "ja"]
    }

    func languageDisplayName(for languageCode: String) -> String {
        switch languageCode {
        case "en":
            return "English"
        case "zh-Hans":
            return "简体中文"
        case "zh-Hant":
            return "繁体中文"
        case "ja":
            return "日本語"
        default:
            return "English"
        }
    }
}
