//
//  AudioEditView.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import SwiftUI

struct AudioEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: CatViewModel
    @Binding var soundToEdit: Sound
    @State private var editedName: String = ""

    init(soundToEdit: Binding<Sound>) {
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
        print(editedName)
        soundToEdit.name = editedName
        print(soundToEdit.name)
        // Update sound in the ViewModel
        if let index = vm.cat.sounds.firstIndex(where: { $0.id == soundToEdit.id }) {
            vm.cat.sounds[index] = soundToEdit
                   vm.cat.sounds = vm.cat.sounds // 触发视图刷新
        }

        // Dismiss the view after saving
        presentationMode.wrappedValue.dismiss()
    }
}

