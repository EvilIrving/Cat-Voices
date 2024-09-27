//
//  CatsView.swift
//  Voices
//
//  Created by Actor on 2024/9/27.
//

import SwiftUI
import SwiftData

struct CatsView: View {
    @Query var cats: [Cat]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cats) { cat in
                    NavigationLink(value: cat) {
                        Text(cat.name)
                    }
                }
            }
            .navigationTitle("FaceFacts")
            .navigationDestination(for: Cat.self) { cat in
                Text(cat.name)
            }
        }
    }
}
