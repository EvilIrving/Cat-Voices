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
            List {
                ForEach(events) { event in
                    EventRow(event: event)
                }
                .onDelete(perform: deleteEvent)
            }
            .navigationTitle("提醒事项")
            .toolbar {
                Button(action: {
                    showingNewEventSheet = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingNewEventSheet) {
                NewEventView()
            }
        }
    }
    
    func deleteEvent(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(events[index])
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

// 预览代码
#Preview {
    do {
        let previewer = try Previewer()
        return EventsView()
            .modelContainer(previewer.container)
            .environmentObject(AppState())
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
