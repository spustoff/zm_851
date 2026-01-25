import SwiftUI

struct HabitTrackerView: View {
    @StateObject private var viewModel = HabitTrackerViewModel()
    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if viewModel.habits.isEmpty {
                            emptyStateView
                        } else {
                            ForEach(viewModel.habits) { habit in
                                HabitRow(habit: habit, viewModel: viewModel)
                                    .onTapGesture {
                                        selectedHabit = habit
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Habit Tracker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "F3DA36"))
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(viewModel: viewModel)
            }
            .sheet(item: $selectedHabit) { habit in
                HabitDetailView(habit: habit, viewModel: viewModel, isPresented: $selectedHabit)
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "repeat.circle")
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "F3DA36").opacity(0.5))
            
            Text("No Habits Yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Start building better habits today")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .padding(.top, 100)
    }
}

struct HabitRow: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitTrackerViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                withAnimation {
                    viewModel.toggleHabitCompletion(habit)
                }
            }) {
                Image(systemName: habit.isCompletedToday() ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(habit.isCompletedToday() ? Color(hex: "F3DA36") : .white.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(habit.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
                
                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                        Text("\(viewModel.getStreakFor(habit)) day streak")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(hex: "F3DA36"))
                    
                    HStack(spacing: 5) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 12))
                        Text(String(format: "%.0f%%", habit.completionRate() * 100))
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(hex: "500180"))
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteHabit(habit)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HabitTrackerViewModel
    
    @State private var name = ""
    @State private var description = ""
    @State private var frequency: Habit.Frequency = .daily
    @State private var targetDaysPerWeek = 7
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Habit Details")) {
                        TextField("Name", text: $name)
                        TextField("Description (optional)", text: $description)
                        
                        Picker("Frequency", selection: $frequency) {
                            ForEach(Habit.Frequency.allCases, id: \.self) { freq in
                                Text(freq.rawValue).tag(freq)
                            }
                        }
                        
                        Stepper("Target: \(targetDaysPerWeek) days/week", value: $targetDaysPerWeek, in: 1...7)
                    }
                }
            }
            .navigationTitle("New Habit")
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
                        viewModel.addHabit(name: name, description: description, frequency: frequency, targetDaysPerWeek: targetDaysPerWeek)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                    .foregroundColor(Color(hex: "F3DA36"))
                }
            }
        }
    }
}

struct HabitDetailView: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitTrackerViewModel
    @Binding var isPresented: Habit?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Name")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(habit.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        if !habit.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(habit.description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack(spacing: 30) {
                            VStack(spacing: 10) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "F3DA36"))
                                
                                Text("\(viewModel.getStreakFor(habit))")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Day Streak")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                            
                            VStack(spacing: 10) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "500180"))
                                
                                Text(String(format: "%.0f%%", habit.completionRate() * 100))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Completion")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(habit.frequency.rawValue) - \(habit.targetDaysPerWeek) days/week")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Completions")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(habit.completionDates.count) times")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            viewModel.toggleHabitCompletion(habit)
                            isPresented = nil
                        }) {
                            Text(habit.isCompletedToday() ? "Mark as Incomplete Today" : "Mark as Complete Today")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "B40814"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "F3DA36"))
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle("Habit Details")
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
