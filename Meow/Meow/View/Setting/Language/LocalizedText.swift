//
//  LocalizedText.swift
//  Meow
//
//  Created by Actor on 2024/10/18.
//


import SwiftUI

struct LocalizedText: View {
    @StateObject private var languageManager = LanguageManager.shared
    let key: LocalizedStringKey
    
    var body: some View {
        Text(key)
            .id(languageManager.currentLanguage)
    }
}
