import SwiftUI

struct HobbyJournalView: View {
    @StateObject private var viewModel = HobbyJournalViewModel()
    @State private var showingAddEntry = false
    @State private var selectedEntry: HobbyEntry?
    @State private var selectedHobby: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Hobby Filter
                    if !viewModel.getUniqueHobbies().isEmpty {
                        hobbyScrollView
                            .padding(.vertical, 10)
                    }
                    
                    // Entries List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if filteredEntries.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(filteredEntries) { entry in
                                    HobbyEntryRow(entry: entry)
                                        .onTapGesture {
                                            selectedEntry = entry
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Hobby Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "F3DA36"))
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddHobbyEntryView(viewModel: viewModel)
            }
            .sheet(item: $selectedEntry) { entry in
                HobbyEntryDetailView(entry: entry, viewModel: viewModel, isPresented: $selectedEntry)
            }
        }
    }
    
    var hobbyScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                HobbyChip(
                    title: "All Hobbies",
                    isSelected: selectedHobby == nil,
                    action: { selectedHobby = nil }
                )
                
                ForEach(viewModel.getUniqueHobbies(), id: \.self) { hobby in
                    HobbyChip(
                        title: hobby,
                        isSelected: selectedHobby == hobby,
                        action: { selectedHobby = hobby }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    var filteredEntries: [HobbyEntry] {
        if let hobby = selectedHobby {
            return viewModel.getEntriesFor(hobby: hobby)
        }
        return viewModel.entries.sorted { $0.date > $1.date }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "paintbrush")
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "F3DA36").opacity(0.5))
            
            Text("No Entries Yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Start documenting your hobby journey")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .padding(.top, 100)
    }
}

struct HobbyChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? Color(hex: "B40814") : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "F3DA36") : Color.white.opacity(0.2))
                .cornerRadius(20)
        }
    }
}

struct HobbyEntryRow: View {
    let entry: HobbyEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.hobbyName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(entry.date, style: .date)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(entry.skillLevel.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(hex: "500180"))
                        .cornerRadius(8)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text("\(entry.duration) min")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(hex: "F3DA36"))
                }
            }
            
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(2)
            }
            
            if !entry.achievements.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(entry.achievements, id: \.self) { achievement in
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                Text(achievement)
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                // Delete handled in detail view
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct AddHobbyEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HobbyJournalViewModel
    
    @State private var hobbyName = ""
    @State private var duration = 30
    @State private var notes = ""
    @State private var skillLevel: HobbyEntry.SkillLevel = .beginner
    @State private var achievementText = ""
    @State private var achievements: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Entry Details")) {
                        TextField("Hobby Name", text: $hobbyName)
                        
                        Stepper("Duration: \(duration) minutes", value: $duration, in: 5...300, step: 5)
                        
                        Picker("Skill Level", selection: $skillLevel) {
                            ForEach(HobbyEntry.SkillLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                    }
                    
                    Section(header: Text("Notes")) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                    }
                    
                    Section(header: Text("Achievements")) {
                        HStack {
                            TextField("Add achievement", text: $achievementText)
                            Button(action: {
                                if !achievementText.isEmpty {
                                    achievements.append(achievementText)
                                    achievementText = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color(hex: "F3DA36"))
                            }
                        }
                        
                        ForEach(achievements, id: \.self) { achievement in
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(hex: "F3DA36"))
                                    .font(.system(size: 12))
                                Text(achievement)
                                Spacer()
                                Button(action: {
                                    achievements.removeAll { $0 == achievement }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(hex: "F3DA36"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addEntry(
                            hobbyName: hobbyName,
                            duration: duration,
                            notes: notes,
                            skillLevel: skillLevel,
                            achievements: achievements
                        )
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(hobbyName.isEmpty)
                    .foregroundColor(Color(hex: "F3DA36"))
                }
            }
        }
    }
}

struct HobbyEntryDetailView: View {
    let entry: HobbyEntry
    @ObservedObject var viewModel: HobbyJournalViewModel
    @Binding var isPresented: HobbyEntry?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hobby")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(entry.hobbyName)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Duration")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                HStack(spacing: 5) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(Color(hex: "F3DA36"))
                                    Text("\(entry.duration) minutes")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Skill Level")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(entry.skillLevel.rawValue)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(hex: "500180"))
                                    .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(entry.date, style: .date)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        
                        if !entry.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(entry.notes)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                        
                        if !entry.achievements.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Achievements")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(entry.achievements, id: \.self) { achievement in
                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color(hex: "F3DA36"))
                                                .font(.system(size: 14))
                                            
                                            Text(achievement)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            viewModel.deleteEntry(entry)
                            isPresented = nil
                        }) {
                            Text("Delete Entry")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.7))
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = nil
                    }
                    .foregroundColor(Color(hex: "F3DA36"))
                }
            }
        }
    }
}
