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
    
    @Published var currentLanguage: LanguageView.Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
            updateLocale()
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
        }
    }
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = LanguageView.Language(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            currentLanguage = LanguageView.Language.fromLocale()
        }
        updateLocale()
    }
    
    private func updateLocale() {
        let localeIdentifier: String
        switch currentLanguage {
        case .english: localeIdentifier = "en"
        case .japanese: localeIdentifier = "ja"
        case .chinese: localeIdentifier = "zh-Hans"
        case .traditionalChinese: localeIdentifier = "zh-Hant"
        }
        UserDefaults.standard.set([localeIdentifier], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
