import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DailyGoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(0)
            
            HabitTrackerView()
                .tabItem {
                    Label("Habits", systemImage: "repeat")
                }
                .tag(1)
            
            LearningHubView()
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(2)
            
            HobbyJournalView()
                .tabItem {
                    Label("Hobbies", systemImage: "paintbrush.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .accentColor(Color(hex: "F3DA36"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
