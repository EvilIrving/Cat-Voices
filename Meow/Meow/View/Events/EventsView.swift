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
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    @State private var showingNewEventSheet = false
    
    var body: some View {
        NavigationView {
            EventsList(events: events, onDelete: deleteEvents)
                .navigationTitle("事项提醒").toolbarTitleDisplayMode(.inline)
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
        do {
            try offsets.forEach { index in
                modelContext.delete(events[index])
            }
            try modelContext.save()
        } catch {
            print("删除事件失败: \(error)")
            // 这里可以添加用户提示逻辑
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
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.eventType.description)
                .font(.headline)
            Text("宠物: \(event.cat.name)")
            Text("提醒时间: \(event.reminderTime, formatter: itemFormatter)")
            Text("重复: \(event.repeatInterval.description)")
        }
    }
}
