import SwiftUI

struct CustomTabsView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            TabView(selection: $selectedTab) {
                // Home Tab
                Text("Home")
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(0)

                // Folder Tab
                Text("Folder")
                    .tabItem {
                        Image(systemName: "folder.fill")
                    }
                    .tag(1)

                // Placeholder for central button, hidden in TabView
                Text("Add")
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tag(2)
                    .hidden() // Hide this from the default tab bar

                // Chat Tab
                Text("Chat")
                    .tabItem {
                        Image(systemName: "ellipsis.bubble.fill")
                    }
                    .tag(3)

                // Profile Tab
                Text("Profile")
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                    }
                    .tag(4)
            }
            .accentColor(.white)
            
            // Custom TabBar overlay with central "+" button
            HStack {
                Spacer()

                // Home Button
                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: "house.fill")
                        .foregroundColor(selectedTab == 0 ? .white : .gray)
                        .frame(maxWidth: .infinity)
                }

                // Folder Button
                Button(action: {
                    selectedTab = 1
                }) {
                    Image(systemName: "folder.fill")
                        .foregroundColor(selectedTab == 1 ? .white : .gray)
                        .frame(maxWidth: .infinity)
                }

                // Central "+" Button
                Button(action: {
                    // Add action for central button
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                    .offset(y: -20) // Lift the central button
                }

                // Chat Button
                Button(action: {
                    selectedTab = 3
                }) {
                    Image(systemName: "ellipsis.bubble.fill")
                        .foregroundColor(selectedTab == 3 ? .white : .gray)
                        .frame(maxWidth: .infinity)
                }

                // Profile Button
                Button(action: {
                    selectedTab = 4
                }) {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(selectedTab == 4 ? .white : .gray)
                        .frame(maxWidth: .infinity)
                }

                Spacer()
            }
            .frame(height: 60)
            .background(Color.black) // Custom tab bar background color
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
 
