//
//  AboutView.swift
//  Test
//
//  Created by Actor on 2024/10/8.
//

import SwiftUI

struct AboutView: View {
    @StateObject private var languageManager = LanguageManager.shared
    var body: some View {
        Text("TODO：关于")
        Text("Languages".localised(using: languageManager.selectedLanguage))
    }
}

#Preview {
    AboutView()
}
