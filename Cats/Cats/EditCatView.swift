//
//  EditCatView.swift
//  Cats
//
//  Created by Actor on 2024/9/27.
//

import SwiftUI

struct EditCatView: View {
    @Bindable var cat: Cat
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $cat.name)
                    .textContentType(.name)
                     
                    .autocapitalization(.words) // Optional: Capitalize words for names
                
                TextField("Age", text: $cat.age)
                    .textContentType(.none)
                    .textInputAutocapitalization(.never)
            }

            Section(header: Text("Description")) {
                TextField("Details about this cat", text: $cat.desc, axis: .vertical)
            }
        }
        .navigationTitle("Edit Cat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveCat()
                }
                .disabled(cat.name.isEmpty) // Disable save button if name is empty
            }
        }
    }
    
    private func saveCat() {
        if !cat.name.isEmpty {
            modelContext.insert(cat)
            dismiss() // Go back after saving
        } else {
            // Optional: Show an alert or indication to the user that the name is required
        }
    }
}

