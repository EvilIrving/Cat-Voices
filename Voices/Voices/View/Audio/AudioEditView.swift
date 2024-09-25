//
//  AudioEditView.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import SwiftUI

struct AudioEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cat: Cat
    @Binding var soundToEdit: Sound
    
    @State private var editedName: String
    
    init(cat: Binding<Cat>, soundToEdit: Binding<Sound>) {
        self._cat = cat
        self._soundToEdit = soundToEdit
        self._editedName = State(initialValue: soundToEdit.wrappedValue.name)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Edit Sound Name")) {
                        TextField("Sound Name", text: $editedName)
                    }
                }
                
                Button(action: saveChanges) {
                    Text("Save")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Edit Sound", displayMode: .inline)
            .navigationBarItems(leading: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveChanges() {
        // Update the sound with the new name
        soundToEdit.name = editedName

        // Find the index of the sound and update it in the cat's sounds array
        if let index = cat.sounds.firstIndex(where: { $0.id == soundToEdit.id }) {
            cat.sounds[index] = soundToEdit

            // Trigger an update by re-assigning the sounds array
            let updatedSounds = cat.sounds
            cat.sounds = updatedSounds
        }

        // Dismiss the view after saving
        presentationMode.wrappedValue.dismiss()
    }
}
