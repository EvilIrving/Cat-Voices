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
    @Published var selectedLanguage = "zh-Hans"

    func setLanguage(_ languageCode: String) {
        if Bundle.main.localizations.contains(languageCode) {
            UserDefaults.standard.set([languageCode], forKey: "MyLanguages")
            selectedLanguage = languageCode
        }
    }

    var supportedLanguages: [String] {
        return ["en", " ja", "zh-Hant", "zh-Hans"]
    }

    func languageDisplayName(for languageCode: String) -> String {
        switch languageCode {
        case "en":
            return "English"
      
        case "zh-Hant":
            return "繁体中文"
        case "ja":
            return "日本語"
        case "zh-Hans":
            return "简体中文"
        default:
            return "简体中文"
        }
    }
}
