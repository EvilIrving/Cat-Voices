//
//  ContentView.swift
//  TabViewDemo
//
//  Created by Actor on 2024/10/17.
//

 
 
import SwiftUI
 

// Custom shape for the curved tab bar
struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 左侧
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: 0))
       
        // 中间半圆弧度
        path.addArc(
            center: CGPoint(x: rect.width * 0.5,y:0),
            radius: rect.width * 0.12,
            startAngle: .degrees(170),
            endAngle: .degrees(0),
            clockwise: true
        )
         
        
        // 右侧
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        return path
    }
}

struct CustomTabItem: Identifiable {
    let id = UUID()
    let icon: String
    let selectedIcon: String
    let title: String
}

struct CustomTabView<Content: View>: View {
    @Binding var selectedTab: Int
    let items: [CustomTabItem]
    @ViewBuilder let content: Content
    
    init(selectedTab: Binding<Int>,
         items: [CustomTabItem],
         @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.items = items
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Tab Bar Container
            ZStack {
                // Custom Tab Bar with curved shape
                HStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        if index == 2 {
                            // Center placeholder for plus button
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        } else {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTab = index
                                }
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: selectedTab == index ? item.selectedIcon : item.icon)
                                        .font(.system(size: 24))
                                    if selectedTab == index {
                                        Text(item.title)
                                            .font(.caption2)
                                    }
                                }
                                .foregroundColor(selectedTab == index ? .primary : .red)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
                .foregroundStyle(.green)
                .background {
                    CurvedShape()
                        .fill(.blue)
                }
                
                // Floating Plus Button
              if selectedTab != 2 {
                  PlusButton {
                      print("Plus button tapped")
                  }
                  .offset(y: -35)
              }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// Enhanced Plus Button Component
struct PlusButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(.white)
                .frame(width: 60, height: 60)
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                .overlay {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.black)
                }
        }
    }
}

// Example Usage
struct ContentView: View {
    @State private var selectedTab = 0
    
    let tabItems = [
        CustomTabItem(icon: "house", selectedIcon: "house.fill", title: "Home"),
        CustomTabItem(icon: "folder", selectedIcon: "folder.fill", title: "Files"),
        CustomTabItem(icon: "plus", selectedIcon: "plus", title: ""), // Placeholder for center button
        CustomTabItem(icon: "message", selectedIcon: "message.fill", title: "Chat"),
        CustomTabItem(icon: "person", selectedIcon: "person.fill", title: "Profile")
    ]
    
    var body: some View {
        CustomTabView(selectedTab: $selectedTab, items: tabItems) {
            ZStack {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    FilesView()
                case 2:
                    Color.clear // Placeholder for plus button
                case 3:
                    ChatView()
                case 4:
                    ProfileView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

// Example View Placeholders
struct HomeView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            Text("Home View")
        }
    }
}

struct FilesView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            Text("Files View")
        }
    }
}

struct ChatView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            Text("Chat View")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            Text("Profile View")
        }
    }
}

#Preview {
    ContentView()
}
