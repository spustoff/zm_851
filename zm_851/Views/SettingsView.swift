import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("About")) {
                        HStack {
                            Text("App Name")
                            Spacer()
                            Text("LifeAdvance")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Category")
                            Spacer()
                            Text("Lifestyle & Education")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section(header: Text("App Info")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text("LifeAdvance is your personal companion for growth, productivity, and self-improvement. Track goals, build habits, learn new skills, and document your hobby journey.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                    
                    Section(header: Text("Features")) {
                        FeatureItem(icon: "target", title: "Daily Goals", description: "Set and achieve your daily objectives")
                        FeatureItem(icon: "repeat", title: "Habit Tracker", description: "Build and maintain positive habits")
                        FeatureItem(icon: "book.fill", title: "Learning Hub", description: "Access curated educational content")
                        FeatureItem(icon: "paintbrush.fill", title: "Hobby Journal", description: "Document your creative journey")
                    }
                    
                    Section(header: Text("Actions")) {
                        Button(action: {
                            hasCompletedOnboarding = false
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(Color(hex: "500180"))
                                Text("Show Onboarding Again")
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Button(action: {
                            showingDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                Text("Delete All Data")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Delete All Data"),
                    message: Text("This will permanently delete all your goals, habits, learning progress, and hobby entries. This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        DataService.shared.resetAllData()
                        hasCompletedOnboarding = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "F3DA36"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}
