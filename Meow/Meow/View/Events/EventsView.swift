//
//  EventsView.swift
//  Test
//
//  Created by Actor on 2024/10/16.
//

import SwiftUI
import SwiftData

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
    return formatter
}()

struct EventsView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    @State private var showingNewEventSheet = false
    
    var body: some View {
        NavigationView {
            EventsList(events: events, onDelete: deleteEvents)
                .navigationTitle("Reminder".localised(using: languageManager.selectedLanguage)).toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addButton
                    }
                }
                .sheet(isPresented: $showingNewEventSheet) {
                    NewEventView()
                }
        }
    }
    
    @ViewBuilder
    private var addButton: some View {
        Button(action: {
            showingNewEventSheet = true
        }) {
            Image(systemName: "plus")
        }
    }
    
    private func deleteEvents(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                modelContext.delete(events[index])
            }
            do {
                try modelContext.save()
            } catch {
                print("保存更改时出错: \(error)")
                // 这里可以添加用户提示逻辑
            }
        }
    }
}

struct EventsList: View {
    let events: [Event]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(events) { event in
                EventRow(event: event)
            }
            .onDelete(perform: onDelete)
        }
    }
}

struct EventRow: View {
    @StateObject private var languageManager = LanguageManager.shared
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.eventType.description)
                .font(.headline)
            Text(String(format: "Pet: %@".localised(using: languageManager.selectedLanguage), event.cat.name))
            Text(String(format: "Reminder Time: %@".localised(using: languageManager.selectedLanguage), itemFormatter.string(from: event.reminderTime)))
            Text(String(format: "Repeat: %@".localised(using: languageManager.selectedLanguage), event.repeatInterval.description))
        }
    }
}
